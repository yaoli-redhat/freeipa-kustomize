
OCP_CONFIG ?= config/static/single-pod
OCP_IMAGE_BASE ?= quay.io/freeipa
OCP_IMAGE_NAME ?= freeipa-operator-container
OCP_IMAGE_TAG ?= freeipa-server
OCP_IMAGE := $(OCP_IMAGE_BASE)/$(OCP_IMAGE_NAME):$(OCP_IMAGE_TAG)
OCP_NAMESPACE ?= freeipa

.PHONY: dump-vars
dump-vars:
	@echo OCP_KUSTOMIZE=$(OCP_KUSTOMIZE)
	@echo OCP_CONFIG=$(OCP_CONFIG)
	@echo OCP_IMAGE_BASE=$(OCP_IMAGE_BASE)
	@echo OCP_IMAGE_NAME=$(OCP_IMAGE_NAME)
	@echo OCP_IMAGE_TAG=$(OCP_IMAGE_TAG)
	@echo OCP_IMAGE=$(OCP_IMAGE)
	@echo OCP_NAMESPACE=$(OCP_NAMESPACE)

.PHONY: check-ocp-config
check-ocp-config:
ifeq (,$(OCP_CONFIG))
	@echo "ERROR:OCP_CONFIG is empty"; exit 1
endif
