package controllers

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/62teknologi/62seahorse/62golib/utils"
	"github.com/62teknologi/62seahorse/app/app_constant"
	"github.com/62teknologi/62seahorse/app/helpers"
	"github.com/62teknologi/62seahorse/config"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ModerationSequenceController struct {
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
	ModerationTablePluralLabel   string
	ModerationTable              string
	SequenceSuffixSingularName   string
	SequenceSuffixPluralName     string
	SequenceSuffixSingularLabel  string
	SequenceSuffixTable          string
}

func (ctrl *ModerationSequenceController) Init(ctx *gin.Context) {
	ctrl.PivotModuleName = utils.Pluralize.Singular(ctx.Param("prefix"))
	ctrl.RealName = ctx.Param("table")
	ctrl.SingularName = utils.Pluralize.Singular(ctrl.RealName)
	ctrl.PluralName = utils.Pluralize.Plural(ctrl.RealName)
	ctrl.SingularLabel = ctrl.SingularName
	ctrl.PluralLabel = ctrl.PluralName
	ctrl.Table = helpers.UsePluralize(ctrl.PluralLabel, ctrl.RealName)
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

func (ctrl ModerationSequenceController) Moderate(ctx *gin.Context) {
	ctrl.Init(ctx)

	transformer, err := utils.JsonFileParser(config.Data.SettingPath + "/transformers/request/moderate.json")

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
		moderationSequence := make(map[string]any)
		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("id = ?", ctx.Param("id")).Take(&moderationSequence).Error; err != nil {
			return err
		}

		if fmt.Sprintf("%v", moderationSequence["result"]) != fmt.Sprintf("%v", app_constant.Waiting) && fmt.Sprintf("%v", moderationSequence["result"]) != fmt.Sprintf("%v", app_constant.Pending) {
			return errors.New("Moderation Sequence must be waiting or pending")
		}

		moderationSequenceUser := make(map[string]any)
		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+helpers.UsePluralize(utils.Pluralize.Plural("user"), utils.Pluralize.Singular("user")))).Where("item_id = ?", moderationSequence["id"]).Where("user_id = ?", transformer["moderator_id"]).Take(&moderationSequenceUser).Error; err != nil {
			return errors.New("moderator is not in this moderation sequence")
		}

		moderationSequence["is_current"] = false
		moderationSequence["result"] = transformer["result"]
		moderationSequence["remarks"] = transformer["remarks"]
		moderationSequence["file_id"] = transformer["file_id"]

		moderation := make(map[string]any)
		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTable)).Where("id = ?", moderationSequence["moderation_id"]).Take(&moderation).Error; err != nil {
			return err
		}

		if (fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Pending) && config.Data.UsePending == false && fmt.Sprintf("%v", moderation["is_ordered_items"]) == fmt.Sprintf("%v", 1)) || (fmt.Sprintf("%v", moderation["is_ordered_items"]) != fmt.Sprintf("%v", 1) && fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Pending)) {
			return errors.New("Pending is not allowed")
		}

		if fmt.Sprintf("%v", moderation["status"]) == fmt.Sprintf("%v", app_constant.Approve) {
			return errors.New("Moderation is already finished")
		}

		if fmt.Sprintf("%v", moderation["status"]) == fmt.Sprintf("%v", app_constant.Reject) {
			return errors.New("Moderation is already rejected")
		}

		if fmt.Sprintf("%v", moderation["status"]) == fmt.Sprintf("%v", app_constant.Revise) {
			return errors.New("Moderation is revised")
		}

		if moderation["step_current"] == nil {
			moderation["step_current"] = 1
		} else {
			moderation["step_current"] = utils.ConvertToInt(moderation["step_current"]) + 1
		}

		if fmt.Sprintf("%v", moderation["step_current"]) != fmt.Sprintf("%v", moderationSequence["step"]) && fmt.Sprintf("%v", moderation["is_ordered_items"]) == fmt.Sprintf("%v", 1) {
			return errors.New("Moderation sequence is not current")
		}

		if fmt.Sprintf("%v", moderation["result"]) == fmt.Sprintf("%v", app_constant.Approve) ||
			fmt.Sprintf("%v", moderation["result"]) == fmt.Sprintf("%v", app_constant.Reject) {
			return errors.New("Moderation is already finished")
		}

		moderation["last_item_id"] = moderationSequence["id"]
		unModeratedSequences := make([]map[string]any, 0)

		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("moderation_id = ?", moderation["id"]).Where("result = ? or result = ?", app_constant.Waiting, app_constant.Pending).Where("id != ?", moderationSequence["id"]).Find(&unModeratedSequences).Error; err != nil {
			return err
		}

		if fmt.Sprintf("%v", moderation["is_ordered_items"]) != fmt.Sprintf("%v", 1) {
			moderationSequence["step"] = moderation["step_current"]
		} else {
			if fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Pending) {
				rollbackTo := utils.ConvertToInt(moderationSequence["step"]) - config.Data.RollbackStep
				if rollbackTo < 1 {
					rollbackTo = 1
				}

				if rollbackTo == 1 {
					moderation["step_current"] = nil
				} else {
					moderation["step_current"] = rollbackTo - 1
				}

				if err = tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("moderation_id = ?", moderation["id"]).Where("step = ?", rollbackTo).Updates(map[string]any{
					"is_current": true,
					"result":     app_constant.Waiting,
				}).Error; err != nil {
					return err
				}

				if err = tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("moderation_id = ?", moderation["id"]).Where("step < ?", moderationSequence["step"]).Where("step > ?", rollbackTo).Updates(map[string]any{
					"is_current": false,
					"result":     app_constant.Pending,
				}).Error; err != nil {
					return err
				}
			} else {
				fmt.Println("moderationSequence", moderationSequence)
				if len(unModeratedSequences) > 0 {
					if err = tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("moderation_id = ?", moderation["id"]).Where("step = ?", utils.ConvertToInt(moderationSequence["step"])+1).Updates(map[string]any{
						"is_current": true,
						"result":     app_constant.Waiting,
					}).Error; err != nil {
						return err
					}
				}
			}
		}

		moderationSequence["is_current"] = false

		if fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Approve) {
			if len(unModeratedSequences) == 0 {
				moderation["status"] = app_constant.Approve
			} else {
				moderation["status"] = app_constant.Waiting
			}
		} else {
			moderation["status"] = moderationSequence["result"]
		}

		moderationSequence["moderator_id"] = transformer["moderator_id"]

		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("id = ?", moderationSequence["id"]).Updates(&moderationSequence).Error; err != nil {
			return err
		}

		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTable)).Where("id = ?", moderation["id"]).Updates(&moderation).Error; err != nil {
			return err
		}

		return nil
	}); err != nil {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", err.Error(), nil))
		return
	}

	ctx.JSON(http.StatusOK, utils.ResponseData("success", "create "+ctrl.ModerationTableSingularLabel+" "+ctrl.ModerationTable+" success", transformer))
}

func (ctrl ModerationSequenceController) UpdateModerator(ctx *gin.Context) {
	ctrl.Init(ctx)

	transformer, err := utils.JsonFileParser(config.Data.SettingPath + "/transformers/request/moderator.json")

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
		moderationSequence := make(map[string]any)
		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+ctrl.SequenceSuffixTable)).Where("id = ?", ctx.Param("id")).Take(&moderationSequence).Error; err != nil {
			return err
		}

		if fmt.Sprintf("%v", moderationSequence["result"]) != fmt.Sprintf("%v", app_constant.Waiting) {
			return errors.New("Moderation Sequence must be waiting")
		}

		// delete all moderation_sequence_users
		if err := tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+helpers.UsePluralize(utils.Pluralize.Plural("user"), utils.Pluralize.Singular("user")))).Where("item_id = ?", moderationSequence["id"]).Delete(&moderationSequence).Error; err != nil {
			return err
		}

		// insert new moderation_sequence_users
		createModerationSequenceUser := []map[string]any{}
		for _, v := range transformer["user_ids"].([]any) {
			createModerationSequenceUser = append(createModerationSequenceUser, map[string]any{
				"item_id":       moderationSequence["id"],
				"user_id":       v,
				"moderation_id": moderationSequence["moderation_id"],
			})
		}

		if err = tx.Table(helpers.SetTableName(ctrl.ModuleName, ctrl.ModerationTableSingularName+"_"+helpers.UsePluralize(utils.Pluralize.Plural("user"), utils.Pluralize.Singular("user")))).Create(&createModerationSequenceUser).Error; err != nil {
			return err
		}

		return nil
	}); err != nil {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", err.Error(), nil))
		return
	}

	ctx.JSON(http.StatusOK, utils.ResponseData("success", "update "+ctrl.ModerationTableSingularLabel+" "+ctrl.ModerationTable+" success", transformer))
}
