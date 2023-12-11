package main

import (
	"fmt"
	"net/http"

	"github.com/62teknologi/62seahorse/62golib/utils"
	"github.com/62teknologi/62seahorse/app/http/controllers"
	"github.com/62teknologi/62seahorse/app/http/middlewares"
	"github.com/62teknologi/62seahorse/config"

	"github.com/gin-gonic/gin"
)

func main() {

	configs, err := config.LoadConfig(".", &config.Data)
	if err != nil {
		fmt.Printf("cannot load config: %w", err)
		return
	}

	utils.ConnectDatabase(configs.DBDriver, configs.DBSource1, configs.DBSource2)

	utils.InitPluralize()

	r := gin.Default()

	apiV1 := r.Group("/api/v1/moderation").Use(middlewares.DbSelectorMiddleware())
	{
		apiV1.POST("/:table", func(c *gin.Context) {
			ctrl := controllers.ModerationController{}
			ctrl.Create(c)
		})

		apiV1.PUT(":table/moderation-sequence/:id/moderate", func(c *gin.Context) {
			ctrl := controllers.ModerationSequenceController{}
			ctrl.Moderate(c)
		})

		apiV1.PUT("/:table/moderation-sequence/:id/update-moderator", func(c *gin.Context) {
			ctrl := controllers.ModerationSequenceController{}
			ctrl.UpdateModerator(c)
		})
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, utils.ResponseData("success", "Server running well", nil))
	})

	err = r.Run(configs.HTTPServerAddress)

	if err != nil {
		fmt.Printf("cannot run server: %w", err)
		return
	}
}
