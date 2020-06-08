.PHONY: build
build:
	- $(MAKE) clean
	- $(MAKE) release
	- $(MAKE) zip

clean:
	- rm -rf ./_build/prod/core/ 2>/dev/null
	- rm ./_build/prod/core.tar.gz 2>/dev/null

.PHONY: release
release:
	- nix-shell --arg env \"prod\" --run "mix deps.get"
	- nix-shell --arg env \"prod\" --run "mix release --overwrite --force"

.PHONY: zip
zip:
	- nix-shell --run "tar -C ./_build/prod/rel -czf ./_build/prod/rel/core.tar.gz ./core"
