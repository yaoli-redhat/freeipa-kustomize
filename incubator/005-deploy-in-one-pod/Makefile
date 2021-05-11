# This makefile make life easier for playing with the different
# proof of concepts.

# Customizable cluster domain for deploying wherever we want
CLUSTER_DOMAIN ?= $(shell kubectl get dnses.config.openshift.io/cluster -o json | jq -r '.spec.baseDomain' )
REALM ?= APPS.$(shell echo $(CLUSTER_DOMAIN) | tr  '[:lower:]' '[:upper:]')
TIMESTAMP ?= $(shell date +%Y%m%d%H%M%S)

# Set the container runtime interface
ifneq (,$(shell bash -c "command -v podman 2>/dev/null"))
DOCKER ?= podman
else
ifneq (,$(shell bash -c "command -v docker 2>/dev/null"))
DOCKER ?= docker
else
ifeq (,$(DOCKER))
$(error DOCKER is not set)
endif
endif
endif

# linux
ifneq (,$(shell bash -c "command -v xdg-open" 2>/dev/null))
OPEN := xdg-open
else
# macos
	ifneq (,$(shell bash -c "command -v open" 2>/dev/null))
OPEN := open
	else
OPEN := echo Open
	endif
endif

NAMESPACE=freeipa
ifeq (,$(NAMESPACE))
$(error Not project indicated)
endif

AWAIT_TIMEOUT?=10
FREEIPA_containers=init-container-uuid init-uid-gid-base main

APP?=$(NAMESPACE)
CONTAINERS="$(FREEIPA_containers)"
# Change DOCKER_BASE_IMAGE on your pipeline settings to point to your upstream
DOCKER_BASE_IMAGE ?= quay.io/freeipa
DOCKER_IMAGE ?= $(DOCKER_BASE_IMAGE)/freeipa-openshift-container:freeipa-server


default: help


.PHONY: FORCE
FORCE:

.PHONY: help
help: FORCE
	@cat HELP

.PHONY: dump-vars
dump-vars:
	@echo CLUSTER_DOMAIN=$(CLUSTER_DOMAIN)
	@echo REALM=$(REALM)
	@echo TIMESTAMP=$(TIMESTAMP)
	@echo DOCKER=$(DOCKER)
	@echo NAMESPACE=$(NAMESPACE)
	@echo AWAIT_TIMEOUT=$(AWAIT_TIMEOUT)
	@echo DOCKER_BASE_IMAGE=$(DOCKER_BASE_IMAGE)
	@echo DOCKER_IMAGE=$(DOCKER_IMAGE)

# Check that cluster domain is not empty
.PHONY: check-cluster-domain-not-empty
ifeq (,$(CLUSTER_DOMAIN))
check-cluster-domain-not-empty: FORCE
	@echo "'CLUSTER_DOMAIN' must be specified; Try 'CLUSTER_DOMAIN=my.cluster.domain.com make ...'"
	@exit 1
else
check-cluster-domain-not-empty:
endif

# Check logged in OpenShift cluster
.PHONY: check-logged-in-openshift
ifeq (,$(shell oc whoami 2>/dev/null))
check-logged-in-openshift: FORCE
	@echo "ERROR: You must be logged in OpenShift cluster. Try 'oc login https://mycluster:6443' matching your cluster API endpoint"
	@exit 1
else
check-logged-in-openshift:
endif

# Check APP is not empty
.PHONY: check-app-not-empty
ifeq (,$(APP))
check-app-not-empty: FORCE
	@echo "'APP' must be specified; Try 'APP=my-app-id make $0'"
	@exit 1
else
check-app-not-empty:
endif

# Check DOCKER_IMAGE is not empty
.PHONY: check-docker-image-not-empty
ifeq (,$(DOCKER_IMAGE))
check-docker-image-not-empty: FORCE
	@echo "'DOCKER_IMAGE' must be defined. Eg: 'export DOCKER_IMAGE=quay.io/myusername/freeipa-server:latest'"
	@exit 1
else
check-docker-image-not-empty:
endif

# Build the container image
.PHONY: container-build
container-build: check-docker-image-not-empty Dockerfile
	$(DOCKER) build -t $(DOCKER_IMAGE) -f Dockerfile .

# Push the container image to the container registry
.PHONY: container-push
container-push: check-docker-image-not-empty FORCE
	$(DOCKER) push $(DOCKER_IMAGE)

# Remove container image from the local storage
.PHONY: container-remove
container-remove: check-docker-image-not-empty FORCE
	$(DOCKER) image rm $(DOCKER_IMAGE)

# Validate kubernetes object for the app
.PHONY: app-validate
app-validate: check-logged-in-openshift check-app-not-empty validate-admin validate-user FORCE

validate-admin:
	kustomize build admin | oc create -f - --dry-run=client --validate=true
validate-user:
	kustomize build user | oc create -f - --dry-run=client --validate=true

.PHONY: generate-pod
generate-manifests: user/pod.yaml user/configmap.yaml user/route.yaml FORCE

user/route.yaml: user/route.yaml.envsubst FORCE
	REALM=$(REALM) \
	TIMESTAMP=$(TIMESTAMP) \
	DOCKER_IMAGE=$(DOCKER_IMAGE) \
	CLUSTER_DOMAIN=$(CLUSTER_DOMAIN) \
	envsubst < user/route.yaml.envsubst > user/route.yaml

user/pod.yaml: user/pod.yaml.envsubst FORCE
	REALM=$(REALM) \
	TIMESTAMP=$(TIMESTAMP) \
	DOCKER_IMAGE=$(DOCKER_IMAGE) \
	CLUSTER_DOMAIN=$(CLUSTER_DOMAIN) \
	envsubst < user/pod.yaml.envsubst > user/pod.yaml

user/configmap.yaml: user/configmap.yaml.envsubst FORCE
	REALM=$(REALM) \
	TIMESTAMP=$(TIMESTAMP) \
	DOCKER_IMAGE=$(DOCKER_IMAGE) \
	CLUSTER_DOMAIN=$(CLUSTER_DOMAIN) \
	envsubst < user/configmap.yaml.envsubst > user/configmap.yaml

.PHONY: app-recreate
app-recreate: app-delete app-create

# Deploy the application
.PHONY: app-create
app-create: check-cluster-domain-not-empty check-app-not-empty check-docker-image-not-empty check-logged-in-openshift generate-manifests app-validate FORCE
	kustomize build admin | oc create -f -
	kustomize build user | oc create -f - --as freeipa
	oc get all -n freeipa

# Delete the application from the cluster
.PHONY: app-delete
app-delete: check-logged-in-openshift check-app-not-empty FORCE
	-kustomize build user | oc delete -f - --as freeipa
	-kustomize build admin | oc delete -f -

.PHONY: app-open-console
app-open-console:
	$(OPEN) https://$(NAMESPACE).apps.$(CLUSTER_DOMAIN)

.PHONY: get-info
get-info: check-logged-in-openshift check-app-not-empty
	@echo ">>> oc describe pod/freeipa"
	oc describe pod/freeipa
	@for container in $(shell echo -n $(CONTAINERS)); do make get-info-container container=$${container}; done

.PHONY: check-container-not-empty
ifeq (,$(container))
check-container-not-empty: FORCE
	@[ "$(container)" != "" ] || echo "'container' must be specified: $(CONTAINERS); Try 'make container=my-container-id get-info-container'"
	@[ "$(container)" != "" ] || exit 1
else
check-container-not-empty:
endif

.PHONY: check-logged-in-openshift get-info-container
get-info-container: check-app-not-empty check-container-not-empty
	@echo ">>> container: $(container)"
	@if oc wait --for=condition=ready --timeout=$(AWAIT_TIMEOUT)s pod/freeipa; then oc logs freeipa -c $(container); else oc logs -f freeipa -c $(container) --insecure-skip-tls-verify-backend=true; fi
