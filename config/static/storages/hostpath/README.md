# hostpath storage

Use this configuration only for development, never in a real cluster.

This configuration has been thought to make developer life easier so
that this can be tested from a SNC (Single Node Cluster) as
CodeReadyContainers or a SNC deployed with kcli.

The usage of this configuration require a manual steps into the node
to prepare it.

- Retrieve the namespace information for freeipa for msc, we will need
  it for setting the right context to the hostPath.

  ```shell
  oc describe namespace/freeipa
  ```

- Login into the node:

  ```shell
  oc get nodes
  oc debug nodes/NODE
  ```

- Create the internal path:

  ```shell
  mkdir /opt/freeipa/data
  ```

- Change selinux context for the directory so that it can be accessed
  from the containers.

  ```shell
  chcon -t container_file_t /opt/freeipa/data
  ```

---

Finally you only have to execute the below from the repository base
directory:

```shell
OCP_CONFIG=config/static/storages/hostpath SINGLEPOD_PASSWORD=Secret123 make ocp-create
```

