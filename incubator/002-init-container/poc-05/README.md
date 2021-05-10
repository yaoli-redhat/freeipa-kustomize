# poc-05 init-container

## use-case-a

Proof of Concept that launch ipa-server-install in an initContainer,
preparing the whole data volume.

```shell
oc kustomize admin | oc create -f - ; oc kustomize use-case-a | oc create -f - --as init-container

oc kustomize use-case-a | oc delete -f - --as init-container ; oc kustomize admin | oc delete -f -
```

## use-case-b

```shell
oc kustomize admin | oc create -f - ; oc kustomize use-case-b | oc create -f - --as init-container

oc kustomize use-case-b | oc delete -f - --as init-container ; oc kustomize admin | oc delete -f -
```

## use-case-c

```shell
oc kustomize admin | oc create -f - ; oc kustomize use-case-c | oc create -f - --as init-container

oc kustomize use-case-c | oc delete -f - --as init-container ; oc kustomize admin | oc delete -f -
```
