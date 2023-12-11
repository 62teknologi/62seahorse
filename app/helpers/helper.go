package helpers

import "github.com/62teknologi/62seahorse/config"

func SetTableName(moduleName string, tableName string) string {
	if moduleName == "" {
		return tableName
	}

	return moduleName + "_" + tableName
}

func UsePluralize(pluralName string, singularName string) string {
	if config.Data.UsePluralize {
		return pluralName
	}

	return singularName
}
