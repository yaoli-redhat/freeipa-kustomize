# poc-03 init-container

```shell
oc kustomize admin | oc create -f -
oc kustomize user | oc create -f - --as init-container

oc get all,roles,rolebinding,sa

# oc adm policy add-scc-to-user poc-01 init-container

oc kustomize user | oc delete -f - --as init-container
oc kustomize admin | oc delete -f -
```
