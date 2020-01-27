PROJECT = $(shell pwd)
VERSION := $(if $(GITHUB_REF),$(shell echo "$(GITHUB_REF)" | sed "s:.*/::g"),snapshot)

default: clean zip validator

clean:
	@docker run --rm -i \
		-v $(PROJECT):/src \
		alpine:3.10 \
		rm -rf \
			/src/schemas.zip \
			/src/buildconfig.xml \
			/src/xsd/_includes.xsd \
			/src/target

zip:
	@TIMESTAMP=$(shell date -u --iso-8601=seconds) \
		VERSION=$(VERSION) \
		envsubst < template/zip-readme > $(PROJECT)/xsd/README.md
	@cd xsd && zip -r $(PROJECT)/schemas.zip README.md */*.xsd */*/*.xsd

validator:
	@sh $(PROJECT)/script/prepare_buildconfig.sh > $(PROJECT)/buildconfig.xml
	@cd $(PROJECT)/xsd && sh $(PROJECT)/script/prepare_includes.sh \
		ehf \
		sbdh/StandardBusinessDocumentHeader.xsd \
		ubl/maindoc \
		xhe \
		> $(PROJECT)/xsd/_includes.xsd
	@docker run --rm -i \
		-v $(PROJECT):/src \
		anskaffelser/validator:2.1.0 \
		build -x -n no.anskaffelser.ehf.schemas -b $(VERSION) /src
