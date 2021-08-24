include ../../../../variables.mk
include ../../../../binaries.mk

SINGLEPOD_BASEDOMAIN := $(shell oc get dnses.config.openshift.io/cluster -o json | jq -r .spec.baseDomain )
SINGLEPOD_REALM := APPS.$(shell tr '[:lower:]' '[:upper:]' <<< "$(SINGLEPOD_BASEDOMAIN)" )
SINGLEPOD_HOSTNAME := $(OCP_NAMESPACE).apps.$(SINGLEPOD_BASEDOMAIN)
SINGLEPOD_CA_SUBJECT := CN=freeipa-$(shell date +%Y%m%d%H%M%S ), O=$(SINGLEPOD_REALM)
SINGLEPOD_ENV_FILE := env.properties

SINGLEPOD_SECRETS_FILE := secrets.properties
ifeq (,$(SINGLEPOD_PASSWORD))
$(error "SINGLEPOD_PASSWORD is required for generating the secret with the password; you can set it before call 'make'")
endif

.PHONY: configure
configure:
	@true > $(SINGLEPOD_ENV_FILE)
	@echo "IPA_SERVER_NAMESPACE=$(OCP_NAMESPACE)" >> $(SINGLEPOD_ENV_FILE)
	@echo "IPA_SERVER_REALM=$(SINGLEPOD_REALM)" >> $(SINGLEPOD_ENV_FILE)
	@echo "IPA_SERVER_CA_SUBJECT=$(SINGLEPOD_CA_SUBJECT)" >> $(SINGLEPOD_ENV_FILE)
	@echo "IPA_SERVER_HOSTNAME=$(SINGLEPOD_HOSTNAME)" >> $(SINGLEPOD_ENV_FILE)
	@true > $(SINGLEPOD_SECRETS_FILE)
	@echo "IPA_SERVER_PASSWORD=$(SINGLEPOD_PASSWORD)" >> $(SINGLEPOD_SECRETS_FILE)
	@$(KUSTOMIZE) edit set namespace $(OCP_NAMESPACE)

