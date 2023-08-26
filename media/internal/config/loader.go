package config

import (
	"fmt"
	"strings"

	"github.com/panducks/mungchi/common-go/validate"
	"github.com/spf13/viper"
)

func LoadValidated(path string) (Config, error) {
	if err := readFile(path); err != nil {
		return Config{}, err
	}
	readEnv()

	var cfg Config
	if err := viper.Unmarshal(&cfg); err != nil {
		return Config{}, fmt.Errorf("unmarshaling config: %w", err)
	}

	if err := validate.Struct(&cfg); err != nil {
		return Config{}, fmt.Errorf("validating config: %w", err)
	}

	return cfg, nil
}

func readFile(path string) error {
	viper.SetConfigFile(path)
	if err := viper.ReadInConfig(); err != nil {
		return fmt.Errorf("reading in config: %w", err)
	}
	return nil
}

func readEnv() {
	// APP_FOO_BAR=baz -> cfg.Foo.Bar = "baz"
	viper.SetEnvPrefix("app")
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
}