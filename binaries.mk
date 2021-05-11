ifneq (,$(shell command -v kustomize 2>/dev/null))
OCP_KUSTOMIZE := kustomize
else
OCP_KUSTOMIZE :=
endif

.PHONY: check-kustomize
check-kustomize:
ifeq (,$(OCP_KUSTOMIZE))
	@echo "ERROR:kustomize not found in your path" && exit 1
endif

