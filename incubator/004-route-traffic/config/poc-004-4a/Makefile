
ifeq (,$(EXTERNAL_IP))
$(error EXTERNAL_IP is required for configurin the proof of concept poc-004-4a)
endif

CONFIG_FILE := configmap.properties

.PHONY: app-config
app-config:
	@EXTERNAL_IP=$(EXTERNAL_IP) envsubst < service-tcp.yaml.envsubst > service-tcp.yaml
	@EXTERNAL_IP=$(EXTERNAL_IP) envsubst < service-udp.yaml.envsubst > service-udp.yaml
	@EXTERNAL_IP=$(EXTERNAL_IP) envsubst < service-web.yaml.envsubst > service-web.yaml

