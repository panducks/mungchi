.DEFAULT_GOAL := help

##@ General

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Compile

.PHONY: proto-profile
proto-profile: protoc protoc-gen-go protoc-gen-go-grpc proto-common ## Compile protocol buffers of profile.
	@PATH=$(LOCALPATH) protoc \
		-Iprotos \
		--go_out=. \
		--go_opt=paths=import \
		--go-grpc_out=. \
		--go-grpc_opt=paths=import \
		protos/profile/*.proto

.PHONY: proto-gadak
proto-gadak: protoc protoc-gen-go protoc-gen-go-grpc proto-common ## Compile protocol buffers of gadak.
	@PATH=$(LOCALPATH) protoc \
		-Iprotos \
		--go_out=. \
		--go_opt=paths=import \
		--go-grpc_out=. \
		--go-grpc_opt=paths=import \
		protos/gadak/*.proto

.PHONY: proto-follow
proto-follow: protoc protoc-gen-go protoc-gen-go-grpc proto-common ## Compile protocol buffers of follow.
	@PATH=$(LOCALPATH) protoc \
		-Iprotos \
		--go_out=. \
		--go_opt=paths=import \
		--go-grpc_out=. \
		--go-grpc_opt=paths=import \
		protos/follow/*.proto

.PHONY: proto-common
proto-common: protoc protoc-gen-go protoc-gen-go-grpc ## Compile protocol buffers of common.
	@PATH=$(LOCALPATH) protoc \
		-Iprotos \
		--go_out=. \
		--go_opt=paths=import \
		--go-grpc_out=. \
		--go-grpc_opt=paths=import \
		protos/common/*.proto

##@ Compile Dependencies

## Location to install dependencies to.
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

## Modified path environment variable including dependencies.
LOCALPATH ?= $(LOCALBIN):$(PATH)

## Tool Binaries
PROTOC_GEN_GO ?= $(LOCALBIN)/protoc-gen-go
PROTOC_GEN_GO_GRPC ?= $(LOCALBIN)/protoc-gen-go-grpc

## Tool Versions
PROTOC_GEN_GO_VERSION ?= v1.28.1
PROTOC_GEN_GO_GRPC_VERSION ?= v1.2.0

.PHONY: protoc
protoc: ## Install protoc if necessary.
	@command -v protoc > /dev/null || brew install protoc

.PHONY: protoc-gen-go
protoc-gen-go: $(PROTOC_GEN_GO) ## Install protoc-gen-go locally if necessary.
$(PROTOC_GEN_GO): $(LOCALBIN)
	@test -s $(LOCALBIN)/protoc-gen-go || \
	GOBIN=$(LOCALBIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)

.PHONY: protoc-gen-go-grpc
protoc-gen-go-grpc: $(PROTOC_GEN_GO_GRPC) ## Install protoc-gen-go-grpc locally if necessary.
$(PROTOC_GEN_GO_GRPC): $(LOCALBIN)
	@test -s $(LOCALBIN)/protoc-gen-go-grpc || \
	GOBIN=$(LOCALBIN) go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)

