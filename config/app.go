package config

import (
	"fmt"

	"github.com/spf13/viper"
)

type Config struct {
	HTTPServerAddress string `mapstructure:"HTTP_SERVER_ADDRESS"`
	DBDriver          string `mapstructure:"DB_DRIVER"`
	DBSource1         string `mapstructure:"DB_SOURCE_1"`
	DBSource2         string `mapstructure:"DB_SOURCE_2"`
	SettingPath       string `mapstructure:"SETTING_PATH"`
	ModuleName        string `mapstructure:"MODULE_NAME"`
	ModerationTable   string `mapstructure:"MODERATION_TABLE"`
	SequenceSuffix    string `mapstructure:"SEQUENCE_SUFFIX"`
	UsePluralize      bool   `mapstructure:"USE_PLURALIZE"`
	UsePending        bool   `mapstructure:"USE_PENDING"`
	RollbackStep      int    `mapstructure:"ROLLBACK_STEP"`
}

var Data Config

// LoadConfig reads configuration from file or environment variables.
func LoadConfig(path string, data *Config) (config Config, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigFile(".env")

	viper.SetDefault("HTTP_SERVER_ADDRESS", "0.0.0.0:10081")
	viper.SetDefault("DB_DRIVER", "mysql")
	viper.SetDefault("DB_SOURCE_1", "root@tcp(127.0.0.1:3306)/whale_local?charset=utf8mb4&parseTime=True&loc=Local")
	viper.SetDefault("DB_SOURCE_2", "")

	viper.SetDefault("SETTING_PATH", "setting")

	viper.SetDefault("MODULE_NAME", "mod")
	viper.SetDefault("MODERATION_TABLE", "moderation")
	viper.SetDefault("SEQUENCE_SUFFIX", "sequence")
	viper.SetDefault("USE_PLURALIZE", true)
	viper.SetDefault("USE_PENDING", true)
	viper.SetDefault("ROLLBACK_STEP", 1)

	viper.AutomaticEnv()

	err = viper.ReadInConfig()
	if err != nil {
		fmt.Println(err)
	}

	err = viper.Unmarshal(data)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("setting path : " + data.SettingPath)

	return *data, err
}
