PATH=$(shell pwd)/src/bin:$(shell echo $$PATH)

PROJECT = $(shell pwd)
VERSION := $(if $(GITHUB_REF),$(shell echo "$(GITHUB_REF)" | sed "s:.*/::g"),snapshot)
TIMESTAMP_UNIX = $(shell date -u +%s)
TIMESTAMP = $(shell date -u --date=@$(TIMESTAMP_UNIX) --iso-8601=seconds)
TIMESTAMP_SHORT = $(shell date -u --date=@$(TIMESTAMP_UNIX) +%Y%m%d-%H%M%Sz)

default: clean prepare zip validator

clean:
	@rm -rf $(PROJECT)/target

prepare:
	@mkdir $(PROJECT)/target
	@cp -r src/xsd $(PROJECT)/target/xsd

zip:
	@TIMESTAMP=$(TIMESTAMP) \
		# VERSION=$(VERSION) \
		envsubst < src/template/zip-readme > $(PROJECT)/target/xsd/README.md
	@cd target/xsd \
	 && zip -q9r $(PROJECT)/target/schemas.zip README.md */*.xsd */*/*.xsd

validator:
	@cd $(PROJECT)/src \
	 && prepare_buildconfig > $(PROJECT)/target/buildconfig.xml
	@cd $(PROJECT)/target/xsd && prepare_includes \
		ehf \
		sbdh/StandardBusinessDocumentHeader.xsd \
		ubl/maindoc \
		uncefact-cii/data/standard/CrossIndustryInvoice_100pD16B.xsd \
		xhe/XHE-1.0.xsd \
		> _includes.xsd
	@docker run --rm -i \
		-v $(PROJECT):/src \
		-u $$(id -u) \
		anskaffelser/validator:edge \
		build -x -n no.anskaffelser.ehf.schemas -b $(VERSION) -target /src/target/validator /src
