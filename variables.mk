
OCP_CONFIG ?= config/static/single-pod
OCP_IMAGE_BASE ?= quay.io/freeipa
OCP_IMAGE_NAME ?= freeipa-operator-container
OCP_IMAGE_TAG ?= freeipa-server
OCP_IMAGE := $(OCP_IMAGE_BASE)/$(OCP_IMAGE_NAME):$(OCP_IMAGE_TAG)

.PHONY: dump-vars
dump-vars:
	@echo OCP_KUSTOMIZE=$(OCP_KUSTOMIZE)
	@echo OCP_CONFIG=$(OCP_CONFIG)
	@echo OCP_IMAGE_BASE=$(OCP_IMAGE_BASE)
	@echo OCP_IMAGE_NAME=$(OCP_IMAGE_NAME)
	@echo OCP_IMAGE_TAG=$(OCP_IMAGE_TAG)
	@echo OCP_IMAGE=$(OCP_IMAGE)
