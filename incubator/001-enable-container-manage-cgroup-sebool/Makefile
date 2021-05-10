

.PHONY: help
help:
	@cat HELP.txt

.PHONY: check-loggedin
check-loggedin:
	@oc whoami &>/dev/null

.PHONY: enable-cgroup-sebool
enable-cgroup-sebool: check-loggedin
	@oc create -f 10-enable-container-manage-cgroup-sebool.yaml

.PHONY: disable-cgroup-sebool
disable-cgroup-sebool: check-loggedin
	@oc delete -f 10-enable-container-manage-cgroup-sebool.yaml
