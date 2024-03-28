package controllers

import (
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/62teknologi/62seahorse/62golib/utils"
	"github.com/62teknologi/62seahorse/app/app_constant"
	"github.com/62teknologi/62seahorse/app/helpers"
	"github.com/62teknologi/62seahorse/config"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type ModerationController struct {
	PivotModuleName              string
	RealName                     string
	SingularName                 string
	PluralName                   string
	SingularLabel                string
	PluralLabel                  string
	Table                        string
	ModuleName                   string
	ModerationTableSingularName  string
	ModerationTablePluralName    string
	ModerationTableSingularLabel string
	ModerationTable              string
	SequenceSuffixSingularName   string
	SequenceSuffixPluralName     string
	SequenceSuffixSingularLabel  string
	SequenceSuffixTable          string
}

func (ctrl *ModerationController) Init(ctx *gin.Context) {
	ctrl.PivotModuleName = ctx.Query("prefix") //based on prefix
	ctrl.RealName = ctx.Param("table")
	ctrl.SingularName = utils.Pluralize.Singular(ctrl.RealName)
	ctrl.PluralName = utils.Pluralize.Plural(ctrl.RealName)
	ctrl.SingularLabel = ctrl.SingularName
	ctrl.PluralLabel = ctrl.PluralName
	ctrl.Table = helpers.UsePluralize(ctrl.PluralName, ctrl.RealName)
	ctrl.ModuleName = config.Data.ModuleName
	ctrl.ModerationTableSingularName = utils.Pluralize.Singular(config.Data.ModerationTable)
	ctrl.ModerationTablePluralName = utils.Pluralize.Plural(config.Data.ModerationTable)
	ctrl.ModerationTableSingularLabel = ctrl.ModerationTableSingularName
	ctrl.ModerationTable = helpers.UsePluralize(ctrl.ModerationTablePluralName, config.Data.ModerationTable)
	ctrl.SequenceSuffixSingularName = utils.Pluralize.Singular(config.Data.SequenceSuffix)
	ctrl.SequenceSuffixPluralName = utils.Pluralize.Plural(config.Data.SequenceSuffix)
	ctrl.SequenceSuffixSingularLabel = ctrl.SequenceSuffixSingularName
	ctrl.SequenceSuffixTable = helpers.UsePluralize(ctrl.SequenceSuffixPluralName, config.Data.SequenceSuffix)
}

func (ctrl ModerationController) Create(ctx *gin.Context) {
	ctrl.Init(ctx)

	transformer, err := utils.JsonFileParser(config.Data.SettingPath + "/transformers/request/create.json")

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

		currentTime := time.Now().Local().UTC()
		formattedTime := currentTime.Format("2006-01-02 15:04:05.000")
		userId := transformer["user_id"]

		// chek prefix_module_name
		// ex hpi_plan_calls
		recordRef := make(map[string]any)
		if err = tx.Table(helpers.SetTableName(
			ctrl.PivotModuleName,
			ctrl.Table)).
			Where("id = ?", transformer["ref_id"]).
			Take(&recordRef).
			Error; err != nil {
			return err
		}

		// check prefix_module_name_moderation
		// ex hpi_plan_call_moderations
		pivotTable := make(map[string]any)
		if err = tx.Table(helpers.SetTableName(
			ctrl.PivotModuleName,
			ctrl.SingularName+"_"+ctrl.ModerationTable)).
			Where(ctrl.SingularLabel+"_id = ?", transformer["ref_id"]).
			Order("id desc").
			Take(&pivotTable).
			Error; err != nil {
			if !errors.Is(err, gorm.ErrRecordNotFound) {
				return err
			}
		}

		createModeration := make(map[string]any)
		createModeration["requested_by"] = transformer["user_id"]
		createModeration["step_total"] = len(transformer["sequence"].([]any))
		createModeration["is_ordered_items"] = transformer["is_ordered_items"]
		createModeration["uuid"] = uuid.New().String()
		createModeration["status"] = app_constant.Waiting
		createModeration["created_at"] = formattedTime
		createModeration["updated_at"] = formattedTime
		createModeration["created_by"] = userId
		createModeration["updated_by"] = userId

		if pivotTable["moderation_id"] != nil {
			moderationCheck := make(map[string]any)
			if err = tx.Table(helpers.SetTableName(
				ctrl.ModuleName,
				ctrl.ModerationTable)).
				Where("id = ?", pivotTable["moderation_id"]).
				Take(&moderationCheck).
				Error; err != nil {
				return err
			}

			if moderationCheck["status"] != nil {
				moderationStatus := fmt.Sprintf("%v", moderationCheck["status"])

				if moderationStatus == fmt.Sprintf("%v", app_constant.Pending) || moderationStatus == fmt.Sprintf("%v", app_constant.Waiting) {
					return errors.New("moderation is already exist")
				}

				if moderationStatus == fmt.Sprintf("%v", app_constant.Approve) {
					return errors.New("moderation is already approved")
				}

				if moderationStatus == fmt.Sprintf("%v", app_constant.Reject) {
					return errors.New("moderation is already rejected")
				}
			}

			createModeration["parent_id"] = pivotTable["moderation_id"]

		}

		// create mod_moderations
		if err = tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTable)).Create(&createModeration).Error; err != nil {
			return err
		}

		moderation := map[string]any{}
		moderationID := createModeration["uuid"]
		tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTable)).
			Where("uuid = ?", moderationID).
			Take(&moderation)

		if transformer["sequence"] != nil {
			for i, v := range transformer["sequence"].([]any) {
				createModerationSequence := make(map[string]any)
				createModerationSequence["moderation_id"] = moderation["id"]
				createModerationSequence["result"] = app_constant.Waiting
				createModerationSequence["uuid"] = uuid.New().String()
				createModerationSequence["created_at"] = formattedTime
				createModerationSequence["updated_at"] = formattedTime
				createModerationSequence["created_by"] = userId
				createModerationSequence["updated_by"] = userId

				if fmt.Sprintf("%v", moderation["is_ordered_items"]) == fmt.Sprintf("%v", 1) {
					createModerationSequence["step"] = i + 1
					if i == 0 {
						createModerationSequence["is_current"] = true
					}
				}

				// create mod_moderation_items
				if err = tx.Table(helpers.SetTableName(
					ctrl.ModuleName,
					ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable,
				)).
					Create(&createModerationSequence).
					Error; err != nil {
					return err
				}

				userIds := v.(map[string]any)["user_ids"]
				if userIds != nil {
					moderationSequence := make(map[string]any)
					tx.Table(helpers.SetTableName(
						ctrl.ModuleName,
						ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).
						Where(createModerationSequence).
						Take(&moderationSequence)

					createModerationSequenceUsers := []map[string]any{}
					for _, w := range userIds.([]any) {
						cmu := map[string]any{
							"created_at":    formattedTime,
							"updated_at":    formattedTime,
							"item_id":       moderationSequence["id"],
							"moderation_id": moderation["id"],
							"user_id":       w,
							"created_by": userId,
							"updated_by": userId,
						}

						createModerationSequenceUsers = append(createModerationSequenceUsers, cmu)
					}

					// create mod_moderation_users
					if err = tx.Table(helpers.SetTableName(
						ctrl.ModuleName,
						ctrl.ModerationTableSingularName+"_"+helpers.UsePluralize(
							utils.Pluralize.Plural("user"),
							utils.Pluralize.Singular("user")))).
						Create(&createModerationSequenceUsers).
						Error; err != nil {
						return err
					}
				}
			}
		}

		createPivot := make(map[string]any)
		createPivot["moderation_id"] = moderation["id"]
		createPivot[ctrl.SingularLabel+"_id"] = transformer["ref_id"]

		// crete pivot_table_moderation
		// ex hpi_plan_call_moderations
		if err = tx.Table(helpers.SetTableName(
			ctrl.PivotModuleName,
			ctrl.SingularName+"_"+ctrl.ModerationTable)).
			Create(&createPivot).
			Error; err != nil {
			return err
		}

		return nil
	}); err != nil {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", err.Error(), nil))
		return
	}

	ctx.JSON(
		http.StatusOK,
		utils.ResponseData(
			"success",
			"create "+ctrl.ModerationTableSingularLabel+" "+ctrl.ModerationTable+" success",
			transformer))
}
