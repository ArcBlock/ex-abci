SRC=./src
DEPS_VER=v0.3.0
DEPS_PREFIX=https://github.com/tyrchen/mix-deps/releases/download
BUILDS_FILE=builds.tgz
DEPS_FILE=deps.tgz
BUILDS_URL=$(DEPS_PREFIX)/$(DEPS_VER)/$(BUILDS_FILE)
DEPS_URL=$(DEPS_PREFIX)/$(DEPS_VER)/$(DEPS_FILE)

extract-deps:
	@cd $(SRC); wget $(BUILDS_URL) --quiet; wget $(DEPS_URL) --quiet; tar zxf $(BUILDS_FILE); tar zxf $(DEPS_FILE); rm $(BUILDS_FILE) $(DEPS_FILE);
	rm -rf $(SRC)/_build/dev/lib/absinthe
	rm -rf $(SRC)/_build/{test,dev,prod,staging}/lib/absinthe
