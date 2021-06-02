#!/bin/bash

[ "${EXTERNAL_IP}" == "" ] && { 
  echo "ERROR: EXTERNAL_IP is not defined"
  exit 2
}

CLIENT_IMAGE="${CLIENT_IMAGE:-quay.io/avisied0/netshoot:latest}"
CLUSTER_DOMAIN="$( oc get dnses.config.openshift.io/cluster -o json | jq -r '.spec.baseDomain' )"
PROJECT_NAME="$( oc project --short=true )"
ENDPOINT="${PROJECT_NAME}.apps.${CLUSTER_DOMAIN}"

ping -c 3 -q "${ENDPOINT}" || {
  echo "${ENDPOINT} should resolve to ${EXTERNAL_IP}"
  echo "Add an entry to /etc/hosts for testing this proof of concept"
  exit 3
}

function verbose
{
  echo "$@" >&2
  "$@"
}

# for port in 31080 31443 31389 31636 31088 31464
for port in 8080 8443 389 636 88 464
do
  STDOUT="$( echo -n "hello world" | nc -4 "${ENDPOINT}" "${port}" )"
  echo -ne "Port ${port}/tcp: "
  if [ "${STDOUT}" == "hello world" ]; then echo "Success"
  else echo ">> Failed"
  fi
done

for port in 88 464
do
  STDOUT="$( ( echo -n "hello world"; sleep 1 ) | nc -4u -w1 test.apps.permanent.idmocp.lab.eng.rdu2.redhat.com "${port}" )"
  echo -ne "Port ${port}/udp: "
  if [ "${STDOUT}" == "hello world" ]; then echo "Success"
  else echo ">> Failed"
  fi
done

verbose oc logs pod/poc-004-4a-services -c http                --tail 7
verbose oc logs pod/poc-004-4a-services -c https               --tail 7
verbose oc logs pod/poc-004-4a-services -c ldap                --tail 7
verbose oc logs pod/poc-004-4a-services -c ldaps               --tail 7
verbose oc logs pod/poc-004-4a-services -c kerberos-tcp        --tail 7
verbose oc logs pod/poc-004-4a-services -c kerberos-admin-tcp  --tail 7

verbose oc logs pod/poc-004-4a-services -c kerberos-udp        --tail 7
verbose oc logs pod/poc-004-4a-services -c kerberos-admin-udp  --tail 7
