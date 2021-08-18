include ../../../../variables.mk
include ../../../../binaries.mk

.PHONY: configure
configure:
	@$(KUSTOMIZE) edit set namespace $(OCP_NAMESPACE)
	@$(MAKE) -C ../../single-pod/ configure
	@-oc create -f pv.yaml
