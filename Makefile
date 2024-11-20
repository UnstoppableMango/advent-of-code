_ := $(shell mkdir -p .make bin)
WORKING_DIR := $(shell pwd)

LOCALBIN := ${WORKING_DIR}/bin
BUN      := ${LOCALBIN}/bun
DEVOPS   := ${LOCALBIN}/devops
DENO     := ${LOCALBIN}/deno
DOTNET   := ${LOCALBIN}/dotnet

build: build_dotnet

build_dotnet: .make/dotnet_build

bin/deno: .versions/deno
	curl -fsSL https://deno.land/install.sh | DENO_INSTALL='${WORKING_DIR}' DENO_VERSION='v$(shell cat $<)' sh
	@touch $@

bin/bun: .versions/bun
	curl -fsSL https://bun.sh/install | BUN_INSTALL='${WORKING_DIR}' bash -s 'bun-v$(shell cat $<)'
	rm _bun # https://github.com/oven-sh/bun/issues/11179
	@touch $@

bin/dotnet-install.sh:
	curl -fsSL https://dot.net/v1/dotnet-install.sh > $@ && chmod +x $@

bin/dotnet: global.json | bin/dotnet-install.sh
	bin/dotnet-install.sh --install-dir ${LOCALBIN} --jsonfile $< --no-path

bin/devops: .versions/devops
	GOBIN=${LOCALBIN} go install github.com/unmango/go/cmd/devops@v$(shell cat $<)

.envrc: hack/example.envrc
	cp $< $@

.make/dotnet_build: $(shell $(DEVOPS) list --dotnet) | bin/devops bin/dotnet
	$(DOTNET) build
	@touch $@

.make/clean_dotnet_install:
	rm -rf ${LOCALBIN}/{host,packs,sdk,sdk-manifests,shared,templates}
	rm -f ${LOCALBIN}/{LICENSE.txt,ThirdPartyNotices.txt,dotnet-install.sh,dotnet}
