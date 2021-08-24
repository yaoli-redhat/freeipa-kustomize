include ../../../../variables.mk
include ../../../../binaries.mk

.PHONY: configure
configure:
	@make -C ../../single-pod/common/ configure
	@$(KUSTOMIZE) edit set namespace $(OCP_NAMESPACE)
	@-oc create -f pv.yaml
