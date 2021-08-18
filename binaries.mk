ifneq (,$(shell bash -c "command -v podman" 2>/dev/null))
DOCKER := podman
else
ifneq (,$(shell bash -c "command -v docker" 2>/dev/null))
DOCKER := docker
else
DOCKER :=
endif
endif

.PHONY: check-docker
check-docker:
ifeq (,$(DOCKER))
	@echo "ERROR:No cocker nor podman found in your path" && exit 1
endif



ifneq (,$(shell command -v kustomize 2>/dev/null))
KUSTOMIZE := kustomize
else
KUSTOMIZE :=
endif

.PHONY: check-kustomize
check-kustomize:
ifeq (,$(KUSTOMIZE))
	@echo "ERROR:kustomize not found in your path" && exit 1
endif

