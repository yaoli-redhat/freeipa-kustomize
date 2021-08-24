include ../../../variables.mk
include ../../../binaries.mk

.PHONY: configure
configure:
	@$(KUSTOMIZE) edit set namespace $(OCP_NAMESPACE)
	@make -C common/ configure

