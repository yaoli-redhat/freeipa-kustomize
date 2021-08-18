# READ THIS BEFORE CHANGE
#
# - Use the suffix 'OCP_' for new variables to be consistent.
# - Add variables into variables.mk file.
# - If the rule does not match with an output result,
#   add '.PHONY: my-rule' before the rule.
# - If new binaries are used, add a section for auto-fill
#   the binary in a variable at binaries.mk file, this will
#   make easier the portability to other systems if the binary
#   changed the name.
#     OCP_MY_NEW_BINARY := $(shell command -v my-new-binary)
#   Add too rule for check the variable when it is used in
#   a rule and add a message error that help to know wha tool
#   is required.
#     .PHONY: check-my-new-binary
#     check-my-new-binary:
#     ifeq (,$(OCP_MY_NEW_BINARY))
#         @echo "ERROR:Descriptive message" && exit 2
#     endif
# - If you are adding a new configuration, create a Makefile
#   which will prepare the property files with the dynamic
#   values, which kustomize will import into ConfigMaps or
#   Secrets.
#
.PHONY: default
default: help

include variables.mk
include binaries.mk

.PHONY: help
help:
	@cat HELP.txt

.PHONY: ocp-create
ocp-create: check-kustomize check-ocp-config
	-oc new-project $(OCP_NAMESPACE)
	$(MAKE) -C config/rbac configure
	$(MAKE) -C $(OCP_CONFIG) configure
	$(KUSTOMIZE) build config/rbac | oc create -f -
	$(KUSTOMIZE) build $(OCP_CONFIG) | oc create -f - --as=freeipa


.PHONY: ocp-build
ocp-build: check-ocp-config check-kustomize
	$(MAKE) -C $(OCP_CONFIG) configure
	$(KUSTOMIZE) build config/rbac
	$(KUSTOMIZE) build $(OCP_CONFIG)


.PHONY: ocp-delete
ocp-delete:
	-$(KUSTOMIZE) build $(OCP_CONFIG) | oc delete -f - --as=freeipa
	-$(KUSTOMIZE) build config/rbac | oc delete -f -


.PHONY: ocp-recreate
ocp-recreate: ocp-delete ocp-create

