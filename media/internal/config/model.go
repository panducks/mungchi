package config

import "github.com/panducks/mungchi/common-go/log"

type Config struct {
	Log LogConfig `mapstructure:"log" validate:"required"`
}

type LogConfig struct {
	Format       log.Format `mapstructure:"format" validate:"required,oneof=json text"`
	Level        log.Level  `mapstructure:"level" validate:"required,oneof=debug info warn error"`
	ReportCaller bool       `mapstructure:"reportCaller"`
}
