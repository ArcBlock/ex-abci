TOP_DIR=.
OUTPUT_DIR=$(TOP_DIR)/output
README=$(TOP_DIR)/README.md

BUILD_NAME=
VERSION=$(strip $(shell cat version))
ELIXIR_VERSION=$(strip $(shell cat .elixir_version))
OTP_VERSION=$(strip $(shell cat .otp_version))

build:
	@echo "Building the software..."
	@make format

format:
	@mix compile; mix format;

init: submodule install dep
	@echo "Initializing the repo..."
	@brew install protobuf
	@mix escript.install hex protobuf

travis-init: submodule extract-deps
	@echo "Initialize software required for travis (normally ubuntu software)"

install:
	@echo "Install software required for this repo..."
	@mix local.hex --force
	@mix local.rebar --force

dep:
	@echo "Install dependencies required for this repo..."
	@mix deps.get

pre-build: install dep
	@echo "Running scripts before the build..."

post-build:
	@echo "Running scripts after the build is done..."

all: pre-build build post-build

test:
	@echo "Running test suites..."
	@MIX_ENV=test mix test

doc:
	@echo "Building the documentation..."

precommit: pre-build build post-build test

travis: precommit

travis-deploy:
	@echo "Deploy the software by travis"
	@make build-release
	@make release

clean: clean-api-docs
	@echo "Cleaning the build..."

watch:
	@make build
	@echo "Watching templates and slides changes..."
	@fswatch -o lib/ config/ | xargs -n1 -I{} make build

run:
	@echo "Running the software..."
	@iex -S mix

submodule:
	@git submodule update --init --recursive

rebuild-deps:
	@rm -rf mix.lock;
	@make dep

rebuild-proto:
	@mkdir -p lib/abci_protos; mkdir -p /tmp/github.com/gogo/protobuf/gogoproto/;mkdir -p /tmp/github.com/tendermint/tendermint/libs/common;
	@curl --silent https://raw.githubusercontent.com/tendermint/tendermint/master/abci/types/types.proto > /tmp/types.proto
	@curl --silent https://raw.githubusercontent.com/gogo/protobuf/master/gogoproto/gogo.proto > /tmp/github.com/gogo/protobuf/gogoproto/gogo.proto
	@curl --silent https://raw.githubusercontent.com/tendermint/tendermint/master/libs/common/types.proto > /tmp/github.com/tendermint/tendermint/libs/common/types.proto
	@rm -rf ./lib/abci_protos/*
	@protoc -I /tmp --elixir_out=plugins=grpc:./lib/abci_protos /tmp/types.proto
	@echo New protobuf files created for tendermint ABCI.

include .makefiles/*.mk

.PHONY: build init travis-init install dep pre-build post-build all test doc precommit travis clean watch run bump-version create-pr submodule build-release
