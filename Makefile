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
	- nix-shell \
	    --arg env \"prod\" \
	    --arg includeDeploy false \
	    --run "mix deps.get"
	- nix-shell \
	    --arg env \"prod\" \
	    --arg includeDeploy false \
	    --run "mix release --overwrite --force"

.PHONY: zip
zip:
	- nix-shell \
	    --arg env \"prod\" \
	    --arg includeDeploy false \
	    --run "tar -C ./_build/prod/rel -czf ./_build/prod/rel/core.tar.gz ./core"


.PHONY: bump
bump:
	- nix-shell \
	    --arg env \"prod\" \
	    --arg includeElixir false \
	    --arg includeDeploy false \
	    --run "./scripts/bump_version $$PWD/VERSION"
