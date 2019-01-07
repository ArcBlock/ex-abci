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

travis-init: submodule
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

dialyzer:
	@echo "Running dialyzer..."
	@mix dialyzer

doc:
	@echo "Building the documentation..."

precommit: pre-build build post-build test

travis: precommit

travis-deploy:
	@echo "Deploy the software by travis"
	@make release

clean:
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

# warning: if you rebuild-proto, please remove the grpc definition in the compiled file. Those parts are not used. If we keep them, we need to include the grpc library, which is unnecessary.
rebuild-proto:
	@rm -rf ./lib/abci_protos/*.pb.ex
	@protoc -I ./lib/abci_protos --elixir_out=plugins=grpc:./lib/abci_protos ./lib/abci_protos/*.proto
	@echo New protobuf files created for tendermint ABCI.

rebuild-proto-old:
	# @protoc -I ./vendors/github.com/tendermint/tendermint/abci/types -I ./vendors --elixir_out=plugins=grpc:./lib/abci_protos vendors/github.com/tendermint/tendermint/abci/types/types.proto
	# @protoc -I ./vendors/github.com/tendermint/tendermint/rpc -I ./vendors --elixir_out=plugins=grpc:./lib/abci_protos vendors/github.com/tendermint/tendermint/rpc/grpc/types.proto
	# @protoc -I ./vendors/github.com/tendermint/tendermint/libs/ -I ./vendors --elixir_out=plugins=grpc:./lib/abci_protos vendors/github.com/tendermint/tendermint/libs/common/types.proto
	# @protoc -I ./vendors/github.com/tendermint/tendermint/crypto -I ./vendors --elixir_out=plugins=grpc:./lib/abci_protos vendors/github.com/tendermint/tendermint/crypto/merkle/merkle.proto
	# @protoc -I ./vendors/github.com/gogo/protobuf/protobuf/google/protobuf -I ./vendors --elixir_out=plugins=grpc:./lib/abci_protos vendors/github.com/gogo/protobuf/protobuf/google/protobuf/timestamp.proto
	@echo New protobuf files created for tendermint ABCI.

include .makefiles/*.mk

.PHONY: build init travis-init install dep pre-build post-build all test dialyzer doc precommit travis clean watch run bump-version create-pr submodule build-release
