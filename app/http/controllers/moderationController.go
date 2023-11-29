package controllers

import (
	"errors"
	"net/http"

	"github.com/62teknologi/62seahorse/62golib/utils"
	"github.com/62teknologi/62seahorse/config"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ModerationController struct {
	SingularName        string
	PluralName          string
	SingularLabel       string
	PluralLabel         string
	Table               string
	PrefixSingularName  string
	PrefixPluralName    string
	PrefixSingularLabel string
	PrefixPluralLabel   string
	PrefixTable         string
}

func (ctrl *ModerationController) Init(ctx *gin.Context) {
	ctrl.SingularName = utils.Pluralize.Singular(ctx.Param("table"))
	ctrl.PluralName = utils.Pluralize.Plural(ctx.Param("table"))
	ctrl.SingularLabel = ctrl.SingularName
	ctrl.PluralLabel = ctrl.PluralName
	ctrl.Table = ctrl.PluralName
	ctrl.PrefixSingularName = utils.Pluralize.Singular(config.Data.Prefix)
	ctrl.PrefixPluralName = utils.Pluralize.Plural(config.Data.Prefix)
	ctrl.PrefixSingularLabel = ctrl.PrefixSingularName
	ctrl.PrefixPluralLabel = ctrl.PrefixPluralName
	ctrl.PrefixTable = ctrl.PrefixPluralName
}

func (ctrl ModerationController) Create(ctx *gin.Context) {
	ctrl.Init(ctx)

	transformer, err := utils.JsonFileParser(config.Data.SettingPath + "/transformers/request/" + ctrl.PluralName + "/create.json")

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, utils.ResponseData("error", err.Error(), nil))
		return
	}

	input := utils.ParseForm(ctx)

	if validation, err := utils.Validate(input, transformer); err {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", "validation", validation.Errors))
		return
	}

	utils.MapValuesShifter(transformer, input)
	utils.MapNullValuesRemover(transformer)

	if err = utils.DB.Transaction(func(tx *gorm.DB) error {
		recordRef := make(map[string]any)
		if err = tx.Table(ctrl.Table).Where("id = ?", transformer["ref_id"]).Take(&recordRef).Error; err != nil {
			return err
		}

		pivotTable := make(map[string]any)
		if err = tx.Table(ctrl.SingularName+"_"+ctrl.PrefixPluralName).Where("record_id = ?", transformer["ref_id"]).Take(&pivotTable).Error; err != nil {
			if !errors.Is(err, gorm.ErrRecordNotFound) {
				return err
			}
		}

		if pivotTable["moderation_id"] != nil {
			return errors.New("moderation already exists")
		}

		createModeration := make(map[string]any)
		createModeration["requested_by"] = transformer["moderator_id"]
		createModeration["step_total"] = len(transformer["sequence"].([]any))
		createModeration["is_in_order"] = transformer["is_in_order"]
		createModeration["uuid"] = uuid.New().String()
		createModeration["status"] = 100

		if transformer["is_in_order"] == true {
			createModeration["step_current"] = 1
		}

		if err = tx.Table(ctrl.PrefixTable).Create(&createModeration).Error; err != nil {
			return err
		}

		moderation := map[string]any{}
		tx.Table(ctrl.PrefixTable).Where(createModeration).Take(&moderation)

		if transformer["sequence"] != nil {
			for i, v := range transformer["sequence"].([]any) {
				createModerationSequence := make(map[string]any)
				createModerationSequence["moderation_id"] = moderation["id"]
				createModerationSequence["moderator_id"] = transformer["moderator_id"]
				createModerationSequence["step"] = i + 1
				createModerationSequence["result"] = 100
				createModerationSequence["uuid"] = uuid.New().String()
				if i == 0 {
					createModerationSequence["is_current"] = true
				}

				if err = tx.Table(ctrl.PrefixSingularName + "_sequences").Create(&createModerationSequence).Error; err != nil {
					return err
				}

				userIds := v.(map[string]any)["user_ids"]
				if userIds != nil {
					moderationSequence := make(map[string]any)
					tx.Table(ctrl.PrefixSingularName + "_sequences").Where(createModerationSequence).Take(&moderationSequence)
					createModerationSequenceUsers := []map[string]any{}
					for _, w := range userIds.([]any) {
						cmu := map[string]any{
							"moderation_sequence_id": moderationSequence["id"],
							"user_id":                w,
						}

						createModerationSequenceUsers = append(createModerationSequenceUsers, cmu)
					}

					if err = tx.Table(ctrl.PrefixSingularName + "_sequence_users").Create(&createModerationSequenceUsers).Error; err != nil {
						return err
					}
				}
			}
		}

		createPivot := make(map[string]any)
		createPivot["moderation_id"] = moderation["id"]
		createPivot["record_id"] = transformer["ref_id"]

		if err = tx.Table(ctrl.SingularName + "_" + ctrl.PrefixPluralName).Create(&createPivot).Error; err != nil {
			return err
		}

		return nil
	}); err != nil {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", err.Error(), nil))
		return
	}

	ctx.JSON(http.StatusOK, utils.ResponseData("success", "create "+ctrl.PrefixSingularLabel+" "+ctrl.PrefixTable+" success", transformer))
}
