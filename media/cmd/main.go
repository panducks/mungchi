package main

import (
	"flag"
	"os"

	"github.com/panducks/mungchi/common-go/log"

	"github.com/panducks/mungchi/media/internal/config"
)

var configPath = flag.String("config", "config.yaml", "YAML config file path")

func init() {
	flag.Parse()
}

func main() {
	cfg, err := config.LoadValidated(*configPath)
	if err != nil {
		log.L().Error("Failed to load config", "error", err)
		os.Exit(1)
	}
	cfgHub := config.NewHub(cfg)

	log.Init(cfgHub.LogConfig())

	log.L().Info("Hello, world!")
}
