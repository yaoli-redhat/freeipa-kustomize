
ifneq (,$(shell command -v podman 2>/dev/null))
DOCKER ?= podman
else
ifneq (,$(shell command -v docker 2>/dev/null))
DOCKER ?= docker
else
DOCKER ?=
endif
endif

NAMESPACE=$(shell oc project -q)
ifeq (,$(NAMESPACE))
$(error Not project selected or not logged in an cluster)
endif

AWAIT_TIMEOUT ?= 10
APP_list := poc-004-1 poc-004-2 poc-004-3 poc-004-4a poc-004-4b poc-004-4c poc-004-4d
POC_004_containers := http https ldap ldaps kerberos-tcp kerberos-udp kerberos-admin-tcp kerberos-admin-udp

# APP=poc-004-1
CONTAINERS="$($(shell echo $(APP) | tr '[:lower:]' '[:upper:]' | tr '-' '_' )_containers)"
# Change DOCKER_IMAGE on your pipeline settings to point to your upstream
# DOCKER_BASE ?= quay.io/freeipa
ifeq (,$(DOCKER_BASE))
$(error DOCKER_BASE is not set)
endif
DOCKER_IMAGE ?= $(DOCKER_BASE)/freeipa-operator:poc-004

# Environment variables used by the container
ECHO_ADDRESS ?= 0.0.0.0
ECHO_PORT ?= 8007
ECHO_MAX_CLIENTS ?= 1

.PHONY: help
help:
	@cat HELP.txt

.PHONY: FORCE
FORCE:

# Check the container frontend was found
.PHONY: check-docker
ifeq (,$(DOCKER))
check-docker:
	@echo "No docker nor podman found in the system"; exit 1
else
check-docker:
endif

# Check logged in OpenShift cluster
.PHONY: check-logged-in-openshift
ifeq (,$(shell oc whoami 2>/dev/null))
check-logged-in-openshift: FORCE
	@echo "ERROR: You must be logged in OpenShift cluster. Try 'oc login https://mycluster' matching your cluster API endpoint"
	@exit 1
else
check-logged-in-openshift:
endif

# Check APP is not empty
.PHONY: check-app-not-empty
ifeq (,$(APP))
check-app-not-empty: FORCE
	@echo "'APP' must be specified: $(APP_list); Try 'APP=my-app-id make $0'"
	@exit 1
else
check-app-not-empty:
endif

# Check DOCKER_IMAGE is not empty
.PHONY: check-docker-image-not-empty
ifeq (,$(DOCKER_IMAGE))
check-docker-image-not-empty: FORCE
	@echo "'DOCKER_IMAGE' must be defined. Eg: 'export DOCKER_IMAGE=quay.io/myusername/freeipa-server:dev-test-003'"
	@exit 1
else
check-docker-image-not-empty:
endif

.PHONY: check-container-not-empty
ifeq (,$(container))
check-container-not-empty: FORCE
	@[ "$(container)" != "" ] || echo "'container' must be specified: $(CONTAINERS); Try 'make APP=$(APP) container=my-container-id get-info-container'"
	@[ "$(container)" != "" ] || exit 1
else
check-container-not-empty:
endif

.PHONY: container-build
container-build: check-docker check-docker-image-not-empty
	$(DOCKER) build -t $(DOCKER_IMAGE) .

.PHONY: container-push
container-push: check-docker check-docker-image-not-empty
	$(DOCKER) push $(DOCKER_IMAGE)

.PHONY: run-udp
run-udp: check-docker
	$(DOCKER) run --rm -it -p$(ECHO_PORT):$(ECHO_PORT)/udp -e ECHO_PROTOCOL=udp -e ECHO_ADDRESS=$(ECHO_ADDRESS) -e ECHO_PORT=$(ECHO_PORT) $(DOCKER_IMAGE)

.PHONY: run-tcp
run-tcp: check-docker check-docker-image-not-empty
	$(DOCKER) run --rm -it -p$(ECHO_PORT):$(ECHO_PORT)/tcp -e ECHO_PROTOCOL=tcp -e ECHO_ADDRESS=$(ECHO_ADDRESS) -e ECHO_PORT=$(ECHO_PORT) -e ECHO_MAX_CLIENTS=$(ECHO_MAX_CLIENTS) $(DOCKER_IMAGE)

# Validate kubernetes object for the app
.PHONY: app-validate
app-validate: check-logged-in-openshift check-app-not-empty FORCE
	kustomize build config/$(APP) | oc create -f - --dry-run=client --validate
	# oc create -f $(APP).yaml --dry-run --validate
	# # oc create -f $(APP)-admin.yaml --dry-run --validate
	# oc create -f poc-004-admin.yaml --dry-run --validate

.PHONY: app-config
app-config: check-app-not-empty
	@[ ! -e config/$(APP)/Makefile ] || make -C config/$(APP)/ app-config

# Deploy the application
.PHONY: app-create
app-create: check-logged-in-openshift check-app-not-empty config/$(APP) app-config app-validate FORCE
	# # oc create -f $(APP)-admin.yaml
	# oc apply -f poc-004-admin.yaml || true
	# # oc adm policy add-scc-to-user $(APP) system:serviceaccount:$(NAMESPACE):$(APP)
	# oc create -f $(APP).yaml
	kustomize build config/$(APP) | oc create -f -

# Delete the application from the cluster
.PHONY: app-delete
app-delete: check-logged-in-openshift check-app-not-empty FORCE
	# oc delete all,cm,sa,role,rolebinding,psp,scc,clusterrole,clusterrolebinding -l app=$(APP)
	-kustomize build config/$(APP) | oc delete -f -

# Read logs
.PHONY: app-info
app-info: check-logged-in-openshift check-app-not-empty
	@echo ">>> oc describe pod/$(APP)"
	oc describe pod/$(APP)
	@for container in $(shell echo -n $(CONTAINERS)); do make app-info-container APP=$(APP) container=$${container}; done

.PHONY: check-logged-in-openshift app-info-container
app-info-container: check-app-not-empty check-container-not-empty
	@echo ">>> container: $(container)"
	if oc wait --for=condition=ready --timeout=$(AWAIT_TIMEOUT)s pod/$(APP); then oc logs $(APP) -c $(container); else oc logs -f $(APP) -c $(container); fi
