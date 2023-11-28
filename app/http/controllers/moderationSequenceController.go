package controllers

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/62teknologi/62seahorse/62golib/utils"
	"github.com/62teknologi/62seahorse/app/app_constant"
	"github.com/62teknologi/62seahorse/config"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ModerationSequenceController struct {
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

func (ctrl *ModerationSequenceController) Init(ctx *gin.Context) {
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

func (ctrl ModerationSequenceController) Moderate(ctx *gin.Context) {
	ctrl.Init(ctx)

	transformer, err := utils.JsonFileParser(config.Data.SettingPath + "/transformers/request/" + ctrl.PluralName + "/moderate.json")

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
		if err := tx.Table(ctrl.PrefixSingularName+"_sequences").Where("id = ?", ctx.Param("id")).Take(&moderationSequence).Error; err != nil {
			return err
		}

		if moderationSequence["is_current"] == false {
			return errors.New("moderation sequence is not current")
		}

		moderationSequenceUser := make(map[string]any)
		if err := tx.Table(ctrl.PrefixSingularName+"_sequence_users").Where("moderation_sequence_id = ?", moderationSequence["id"]).Where("user_id = ?", transformer["moderator_id"]).Take(&moderationSequenceUser).Error; err != nil {
			return errors.New("moderator is not in this moderation sequence")
		}

		moderationSequence["is_current"] = false
		moderationSequence["result"] = transformer["result"]
		moderationSequence["remarks"] = transformer["remarks"]
		moderationSequence["file_id"] = transformer["file_id"]

		moderation := make(map[string]any)
		if err := tx.Table(ctrl.PrefixTable).Where("id = ?", moderationSequence["moderation_id"]).Take(&moderation).Error; err != nil {
			return err
		}

		if fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Approve) ||
			fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Reject) {
			return errors.New("Moderation is already finished")
		}

		if moderation["step_current"] != moderationSequence["step"] {
			return errors.New("Moderation sequence is not current")
		}

		if err := tx.Table(ctrl.PrefixSingularName+"_sequences").Where("id = ?", moderationSequence["id"]).Updates(&moderationSequence).Error; err != nil {
			return err
		}

		moderation["last_moderation_sequence_id"] = moderationSequence["id"]
		if fmt.Sprintf("%v", transformer["result"]) == fmt.Sprintf("%v", app_constant.Approve) {
			if moderationSequence["step"] == moderation["step_total"] {
				moderation["status"] = app_constant.Approve
			} else {
				// convert moderationSequence["step"] to int and add 1
				moderation["step_current"] = moderationSequence["step"].(int64) + 1
				moderation["status"] = app_constant.Pending
			}
		} else {
			moderation["status"] = moderationSequence["result"]
			moderation["step_current"] = moderationSequence["step"]
		}

		if err := tx.Table(ctrl.PrefixTable).Where("id = ?", moderation["id"]).Updates(&moderation).Error; err != nil {
			return err
		}

		return nil
	}); err != nil {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", err.Error(), nil))
		return
	}

	ctx.JSON(http.StatusOK, utils.ResponseData("success", "create "+ctrl.PrefixSingularLabel+" "+ctrl.PrefixTable+" success", transformer))
}

func (ctrl ModerationSequenceController) Update(ctx *gin.Context) {
	ctrl.Init(ctx)

	transformer, err := utils.JsonFileParser(config.Data.SettingPath + "/transformers/request/" + ctrl.PluralName + "/moderate.json")

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
		if err := tx.Table(ctrl.PrefixSingularName+"_sequences").Where("id = ?", ctx.Param("id")).Take(&moderationSequence).Error; err != nil {
			return err
		}

		// delete all moderation_sequence_users
		if err := tx.Table(ctrl.PrefixSingularName+"_sequence_users").Where("moderation_sequence_id = ?", moderationSequence["id"]).Delete(&moderationSequence).Error; err != nil {
			return err
		}

		// insert new moderation_sequence_users
		for _, v := range transformer["user_ids"].([]any) {
			createModerationSequenceUser := make(map[string]any)
			createModerationSequenceUser["moderation_sequence_id"] = moderationSequence["id"]
			createModerationSequenceUser["user_id"] = v

			if err = tx.Table(ctrl.PrefixSingularName + "_sequence_users").Create(&createModerationSequenceUser).Error; err != nil {
				return err
			}
		}

		return nil
	}); err != nil {
		ctx.JSON(http.StatusBadRequest, utils.ResponseData("error", err.Error(), nil))
		return
	}

	ctx.JSON(http.StatusOK, utils.ResponseData("success", "update "+ctrl.PrefixSingularLabel+" "+ctrl.PrefixTable+" success", transformer))
}
