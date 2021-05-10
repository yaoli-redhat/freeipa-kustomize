# poc-01 init-container

```shell
oc kustomize admin | oc create -f -
oc kustomize user | oc create -f - --as init-container

# oc adm policy add-scc-to-user poc-01 test

oc kustomize user | oc delete -f - --as init-container
oc kustomize admin | oc delete -f -
```
