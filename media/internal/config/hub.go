package config

import "github.com/panducks/mungchi/common-go/log"

type Hub struct {
	cfg Config
}

func NewHub(cfg Config) *Hub {
	return &Hub{cfg: cfg}
}

func (h *Hub) LogConfig() log.Config {
	return log.Config{
		Format: h.cfg.Log.Format,
		Level:  h.cfg.Log.Level,
		Caller: h.cfg.Log.ReportCaller,
	}
}
