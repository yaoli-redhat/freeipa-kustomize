# hostpath

This configuration exists only for developing propose.
Do not use this configuration for real clusters; this is
used for developing when using a SNO (Single Node
Openshift) cluster.

Before using this configuration you need to do some manual
configuration into your SNO node:

```shell
oc get nodes # retrieve the node name objects
oc debug nodes/MY-NODE-NAME-OBJECT

chroot /host
mkdir -p /opt/freeipa/data
chcon -R -t container_file_t /opt/freeipa/data
```

After this, you could use the configuration as usual.
