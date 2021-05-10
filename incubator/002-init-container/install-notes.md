# Notes

## It can be seen some reverse DNS resolve at the beginning

```raw
Logging to /var/log/ipaserver-install.log
ipa-server-install was invoked with arguments [] and options: {'unattended': True, 'ip_addresses': None, 'domain_name': None, 'realm_name': 'apps.permanent.idmocp.idm.lab.bos.redhat.com', 'host_name': None, 'ca_cert_files': None, 'domain_level': None, 'setup_adtrust': False, 'setup_kra': False, 'setup_dns': False, 'idstart': None, 'idmax': None, 'no_hbac_allow': False, 'no_pkinit': False, 'no_ui_redirect': False, 'dirsrv_config_file': None, 'dirsrv_cert_files': None, 'http_cert_files': None, 'pkinit_cert_files': None, 'dirsrv_cert_name': None, 'http_cert_name': None, 'pkinit_cert_name': None, 'mkhomedir': False, 'ntp_servers': None, 'ntp_pool': None, 'no_ntp': True, 'force_ntpd': False, 'ssh_trust_dns': False, 'no_ssh': True, 'no_sshd': True, 'no_dns_sshfp': False, 'external_ca': False, 'external_ca_type': None, 'external_ca_profile': None, 'external_cert_files': None, 'subject_base': None, 'ca_subject': None, 'ca_signing_algorithm': None, 'pki_config_override': None, 'allow_zone_overlap': False, 'reverse_zones': None, 'no_reverse': False, 'auto_reverse': False, 'zonemgr': None, 'forwarders': None, 'no_forwarders': False, 'auto_forwarders': False, 'forward_policy': None, 'no_dnssec_validation': False, 'no_host_dns': False, 'enable_compat': False, 'netbios_name': None, 'no_msdcs': False, 'rid_base': None, 'secondary_rid_base': None, 'ignore_topology_disconnect': False, 'ignore_last_of_role': False, 'verbose': True, 'quiet': False, 'log_file': None, 'uninstall': False}
IPA version 4.8.4-7.module_el8.2.0+374+0d2d74a1
Searching for an interface of IP address: ::1
Testing local IP address: ::1/128 (interface: lo)
Starting external process
args=['/usr/sbin/selinuxenabled']
Process finished, return code=1
stdout=
stderr=
Loading StateFile from '/var/lib/ipa/sysrestore/sysrestore.state'
Loading Index file from '/var/lib/ipa/sysrestore/sysrestore.index'
httpd is not configured
kadmin is not configured
dirsrv is not configured
pki-tomcatd is not configured
install is not configured
krb5kdc is not configured
named is not configured
filestore is tracking no files
Loading Index file from '/var/lib/ipa-client/sysrestore/sysrestore.index'
Loading Index file from '/var/lib/ipa/sysrestore/sysrestore.index'
Loading StateFile from '/var/lib/ipa/sysrestore/sysrestore.state'
Check if poc-05-a.apps.permanent.idmocp.idm.lab.bos.redhat.com is a primary hostname for localhost
Primary hostname for localhost: poc-05-a.apps.permanent.idmocp.idm.lab.bos.redhat.com
Search DNS for poc-05-a.apps.permanent.idmocp.idm.lab.bos.redhat.com
Check if poc-05-a.apps.permanent.idmocp.idm.lab.bos.redhat.com is not a CNAME
Check reverse address of 10.143.1.122
Found reverse name: poc-05-a.apps.permanent.idmocp.idm.lab.bos.redhat.com
will use host_name: poc-05-a.apps.permanent.idmocp.idm.lab.bos.redhat.com
```

- It is resolving the POD IP.

## UID/GID in LDAP should match namespace uid/gid ranges?

I can see the below for the step `[27/44]: adding default layout`:

```raw
add objectClass:
	top
	person
	posixaccount
	krbprincipalaux
	krbticketpolicyaux
	inetuser
	ipaobject
	ipasshuser
add uid:
	admin
add krbPrincipalName:
	admin@APPS.PERMANENT.IDMOCP.IDM.LAB.BOS.REDHAT.COM
add cn:
	Administrator
add sn:
	Administrator
add uidNumber:
	127800000
add gidNumber:
	127800000
add homeDirectory:
	/home/admin
add loginShell:
	/bin/bash
add gecos:
	Administrator
add nsAccountLock:
	FALSE
add ipaUniqueID:
	autogenerate
adding new entry "uid=admin,cn=users,cn=accounts,dc=apps,dc=permanent,dc=idmocp,dc=idm,dc=lab,dc=bos,dc=redhat,dc=com"
modify complete
```

## Should ipaBaseID match namespace ranges?

In a similar way, can be seen in the `` step:

```raw
add objectClass:
	top
	ipaIDrange
	ipaDomainIDRange
add cn:
	APPS.PERMANENT.IDMOCP.IDM.LAB.BOS.REDHAT.COM_id_range
add ipaBaseID:
	127800000
add ipaIDRangeSize:
	200000
add ipaRangeType:
	ipa-local
adding new entry "cn=APPS.PERMANENT.IDMOCP.IDM.LAB.BOS.REDHAT.COM_id_range,cn=ranges,cn=etc,dc=apps,dc=permanent,dc=idmocp,dc=idm,dc=lab,dc=bos,dc=redhat,dc=com"
modify complete
```

## Should OpenShift integrate with the ranges specified by Freeipa?



## mount points inside the init-volume container with privileged=true in the pod

```raw
overlay on / type overlay (rw,relatime,context="system_u:object_r:container_file_t:s0:c59,c236",lowerdir=/var/lib/containers/storage/overlay/l/JLYCMCB4IPZEBZXTQ5ODCPBWKU:/var/lib/containers/storage/overlay/l/MOGMTQ4S3VW3EMG5DTS3NGBG7P:/var/lib/containers/storage/overlay/l/XTDUXOLU6TGVJF2PXOQYGURFUZ:/var/lib/containers/storage/overlay/l/VVNVXJ43RBMVW3KYKLXKGAQTVL:/var/lib/containers/storage/overlay/l/3YSFEI6QMK5SFD7SNO2GVI5MCR:/var/lib/containers/storage/overlay/l/DEHYLNVYLVH3BMHUJXYA6VUF6W:/var/lib/containers/storage/overlay/l/UYNKFWOWPVZ7YHLPD2KYJZSKFJ:/var/lib/containers/storage/overlay/l/2CP7NW7EEWTVNRWHE2L7USZXOS:/var/lib/containers/storage/overlay/l/3B2K6LWXIOVGPC4CNOXZIZ3RXX:/var/lib/containers/storage/overlay/l/T656HYDE45DCBVL2VCYMSLTD5M:/var/lib/containers/storage/overlay/l/5EKTAID43DODQNLD622JSZFRSV:/var/lib/containers/storage/overlay/l/YZYK3OBKTNYLJJOB5QGLP3ODEJ:/var/lib/containers/storage/overlay/l/R5T6L2NJE6K4N3CWWM6NLCGW6C:/var/lib/containers/storage/overlay/l/DEUYK67V7TUJ4ML7ZL45K4OQTC:/var/lib/containers/storage/overlay/l/YJODYPEYFL2VEWUGH2DGQCBSNB:/var/lib/containers/storage/overlay/l/SOSJKS23EE4QLDXFUQR2UMT6CQ:/var/lib/containers/storage/overlay/l/ALX5YSE755V7SADTSSF5QB4HDL:/var/lib/containers/storage/overlay/l/4AXWIYFCKLBLPQIKZ3QZWXN2WP:/var/lib/containers/storage/overlay/l/R6SKHYOFUVGBAR3Q4GGWU3ZYSA:/var/lib/containers/storage/overlay/l/FATKO66KGUW6EDF56HPHLOXBEB:/var/lib/containers/storage/overlay/l/6FPS2RF46XZEVW4SRM5YBWEFLI:/var/lib/containers/storage/overlay/l/TGWYWJQRDDNO7BEPGQQBWSKPVY:/var/lib/containers/storage/overlay/l/MYRV54YBKXGGQUTQK2YX4RN7QM:/var/lib/containers/storage/overlay/l/WJTAKTNKPCFTIVJECTBEHNW6MT:/var/lib/containers/storage/overlay/l/DR2ASASAKZAX5N3OTIKMLFKR54:/var/lib/containers/storage/overlay/l/3UDYYT2ZEVCUVNLWN2MYKAR3DT:/var/lib/containers/storage/overlay/l/XZMNCJNCRTXG4C762KH5JA3RFH:/var/lib/containers/storage/overlay/l/FAHWWYHP5AQ2JKYNPKZI6QY5O7:/var/lib/containers/storage/overlay/l/JX2M26CCQMD2UJIWBLLMYUHVYJ:/var/lib/containers/storage/overlay/l/L44E2ZRVEP27E5S3F7FFYUDRSV:/var/lib/containers/storage/overlay/l/4UGJOQTPZ5Q4LUXNTKHVF7A2OK:/var/lib/containers/storage/overlay/l/VSK6IX5FBZNDBONJDM55RAKAYH:/var/lib/containers/storage/overlay/l/TDO2QNCOXOJLFWMONJP2RLBYKM:/var/lib/containers/storage/overlay/l/6PGDLNXNDUORDJUH7N4THMAK2C:/var/lib/containers/storage/overlay/l/COIVW7UP3OSVIUPAYSR4P5F7TB:/var/lib/containers/storage/overlay/l/4FU3O72DLOIZVJ3LAZRCS2LJLM:/var/lib/containers/storage/overlay/l/IXSK7TF5RYGI774IAGRA45VBKP:/var/lib/containers/storage/overlay/l/MBOS7A3IYQEVXOCGEFG75RURME:/var/lib/containers/storage/overlay/l/OAXZQSICB5VKPVOO6PEZ2L67TX:/var/lib/containers/storage/overlay/l/VOQSTLSCFEAV7VOPYKONFJBMLU:/var/lib/containers/storage/overlay/l/XTDCSOEL4VX4GQBEWURAJURZGL:/var/lib/containers/storage/overlay/l/3XIWKCXPCUTIWGNIV6T4KFKUVQ:/var/lib/containers/storage/overlay/l/T4BVLN6F6GMDMBIAU2MYVMNP2B:/var/lib/containers/storage/overlay/l/DKTPRBCHXXIECB72XESEOP6ZNO:/var/lib/containers/storage/overlay/l/ICJXBJQQ5E3WNE5RXC4GUW6V6M:/var/lib/containers/storage/overlay/l/ZEQ2IY4U3VSSA6TFCYLJA7PV2L,upperdir=/var/lib/containers/storage/overlay/229638443a13f4ce7a6cec63df6adbbe4930200a7dd1d4e29fe16ab8d2a1197e/diff,workdir=/var/lib/containers/storage/overlay/229638443a13f4ce7a6cec63df6adbbe4930200a7dd1d4e29fe16ab8d2a1197e/work)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c59,c236",size=65536k,mode=755)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236",gid=5,mode=620,ptmxmode=666)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime,seclabel)
sysfs on /sys type sysfs (ro,nosuid,nodev,noexec,relatime,seclabel)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236",mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,memory)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpu,cpuacct)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,blkio)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,freezer)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,pids)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,hugetlb)
cgroup on /sys/fs/cgroup/rdma type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,rdma)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,devices)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,net_cls,net_prio)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,cpuset)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,perf_event)
tmpfs on /run type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236",size=65536k)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236",size=65536k)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236")
tmpfs on /var/log/journal type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236")
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c59,c236",size=65536k)
tmpfs on /etc/resolv.conf type tmpfs (rw,nosuid,nodev,noexec,seclabel,mode=755)
tmpfs on /etc/hostname type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
/dev/mapper/coreos-luks-root-nocrypt on /data type xfs (rw,relatime,seclabel,attr2,inode64,prjquota)
/dev/mapper/coreos-luks-root-nocrypt on /etc/hosts type xfs (rw,relatime,seclabel,attr2,inode64,prjquota)
/dev/mapper/coreos-luks-root-nocrypt on /dev/termination-log type xfs (rw,relatime,seclabel,attr2,inode64,prjquota)
tmpfs on /run/secrets type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
tmpfs on /run/secrets/kubernetes.io/serviceaccount type tmpfs (ro,relatime,seclabel)
```

## mount points inside the init-volume container with privileged=false in the pod

```raw
overlay on / type overlay (rw,relatime,context="system_u:object_r:container_file_t:s0:c182,c767",lowerdir=/var/lib/containers/storage/overlay/l/JLYCMCB4IPZEBZXTQ5ODCPBWKU:/var/lib/containers/storage/overlay/l/MOGMTQ4S3VW3EMG5DTS3NGBG7P:/var/lib/containers/storage/overlay/l/XTDUXOLU6TGVJF2PXOQYGURFUZ:/var/lib/containers/storage/overlay/l/VVNVXJ43RBMVW3KYKLXKGAQTVL:/var/lib/containers/storage/overlay/l/3YSFEI6QMK5SFD7SNO2GVI5MCR:/var/lib/containers/storage/overlay/l/DEHYLNVYLVH3BMHUJXYA6VUF6W:/var/lib/containers/storage/overlay/l/UYNKFWOWPVZ7YHLPD2KYJZSKFJ:/var/lib/containers/storage/overlay/l/2CP7NW7EEWTVNRWHE2L7USZXOS:/var/lib/containers/storage/overlay/l/3B2K6LWXIOVGPC4CNOXZIZ3RXX:/var/lib/containers/storage/overlay/l/T656HYDE45DCBVL2VCYMSLTD5M:/var/lib/containers/storage/overlay/l/5EKTAID43DODQNLD622JSZFRSV:/var/lib/containers/storage/overlay/l/YZYK3OBKTNYLJJOB5QGLP3ODEJ:/var/lib/containers/storage/overlay/l/R5T6L2NJE6K4N3CWWM6NLCGW6C:/var/lib/containers/storage/overlay/l/DEUYK67V7TUJ4ML7ZL45K4OQTC:/var/lib/containers/storage/overlay/l/YJODYPEYFL2VEWUGH2DGQCBSNB:/var/lib/containers/storage/overlay/l/SOSJKS23EE4QLDXFUQR2UMT6CQ:/var/lib/containers/storage/overlay/l/ALX5YSE755V7SADTSSF5QB4HDL:/var/lib/containers/storage/overlay/l/4AXWIYFCKLBLPQIKZ3QZWXN2WP:/var/lib/containers/storage/overlay/l/R6SKHYOFUVGBAR3Q4GGWU3ZYSA:/var/lib/containers/storage/overlay/l/FATKO66KGUW6EDF56HPHLOXBEB:/var/lib/containers/storage/overlay/l/6FPS2RF46XZEVW4SRM5YBWEFLI:/var/lib/containers/storage/overlay/l/TGWYWJQRDDNO7BEPGQQBWSKPVY:/var/lib/containers/storage/overlay/l/MYRV54YBKXGGQUTQK2YX4RN7QM:/var/lib/containers/storage/overlay/l/WJTAKTNKPCFTIVJECTBEHNW6MT:/var/lib/containers/storage/overlay/l/DR2ASASAKZAX5N3OTIKMLFKR54:/var/lib/containers/storage/overlay/l/3UDYYT2ZEVCUVNLWN2MYKAR3DT:/var/lib/containers/storage/overlay/l/XZMNCJNCRTXG4C762KH5JA3RFH:/var/lib/containers/storage/overlay/l/FAHWWYHP5AQ2JKYNPKZI6QY5O7:/var/lib/containers/storage/overlay/l/JX2M26CCQMD2UJIWBLLMYUHVYJ:/var/lib/containers/storage/overlay/l/L44E2ZRVEP27E5S3F7FFYUDRSV:/var/lib/containers/storage/overlay/l/4UGJOQTPZ5Q4LUXNTKHVF7A2OK:/var/lib/containers/storage/overlay/l/VSK6IX5FBZNDBONJDM55RAKAYH:/var/lib/containers/storage/overlay/l/TDO2QNCOXOJLFWMONJP2RLBYKM:/var/lib/containers/storage/overlay/l/6PGDLNXNDUORDJUH7N4THMAK2C:/var/lib/containers/storage/overlay/l/COIVW7UP3OSVIUPAYSR4P5F7TB:/var/lib/containers/storage/overlay/l/4FU3O72DLOIZVJ3LAZRCS2LJLM:/var/lib/containers/storage/overlay/l/IXSK7TF5RYGI774IAGRA45VBKP:/var/lib/containers/storage/overlay/l/MBOS7A3IYQEVXOCGEFG75RURME:/var/lib/containers/storage/overlay/l/OAXZQSICB5VKPVOO6PEZ2L67TX:/var/lib/containers/storage/overlay/l/VOQSTLSCFEAV7VOPYKONFJBMLU:/var/lib/containers/storage/overlay/l/XTDCSOEL4VX4GQBEWURAJURZGL:/var/lib/containers/storage/overlay/l/3XIWKCXPCUTIWGNIV6T4KFKUVQ:/var/lib/containers/storage/overlay/l/T4BVLN6F6GMDMBIAU2MYVMNP2B:/var/lib/containers/storage/overlay/l/DKTPRBCHXXIECB72XESEOP6ZNO:/var/lib/containers/storage/overlay/l/ICJXBJQQ5E3WNE5RXC4GUW6V6M:/var/lib/containers/storage/overlay/l/ZEQ2IY4U3VSSA6TFCYLJA7PV2L,upperdir=/var/lib/containers/storage/overlay/448aaacbcbb4ae54e916dba32e9ad2f9938a1f240cf275dc0b8bc3690e175c85/diff,workdir=/var/lib/containers/storage/overlay/448aaacbcbb4ae54e916dba32e9ad2f9938a1f240cf275dc0b8bc3690e175c85/work)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k,mode=755)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767",gid=5,mode=620,ptmxmode=666)
mqueue on /dev/mqueue type mqueue (rw,nosuid,nodev,noexec,relatime,seclabel)
sysfs on /sys type sysfs (ro,nosuid,nodev,noexec,relatime,seclabel)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767",mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/memory type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,memory)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,cpu,cpuacct)
cgroup on /sys/fs/cgroup/blkio type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,blkio)
cgroup on /sys/fs/cgroup/freezer type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,freezer)
cgroup on /sys/fs/cgroup/pids type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,pids)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,hugetlb)
cgroup on /sys/fs/cgroup/rdma type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,rdma)
cgroup on /sys/fs/cgroup/devices type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,devices)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,net_cls,net_prio)
cgroup on /sys/fs/cgroup/cpuset type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,cpuset)
cgroup on /sys/fs/cgroup/perf_event type cgroup (ro,nosuid,nodev,noexec,relatime,seclabel,perf_event)
tmpfs on /run type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k)
tmpfs on /run/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k)
tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767")
tmpfs on /var/log/journal type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767")
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,seclabel,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
shm on /dev/shm type tmpfs (rw,nosuid,nodev,noexec,relatime,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k)
tmpfs on /etc/resolv.conf type tmpfs (rw,nosuid,nodev,noexec,seclabel,mode=755)
tmpfs on /etc/hostname type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
/dev/mapper/coreos-luks-root-nocrypt on /data type xfs (rw,relatime,seclabel,attr2,inode64,prjquota)
/dev/mapper/coreos-luks-root-nocrypt on /etc/hosts type xfs (rw,relatime,seclabel,attr2,inode64,prjquota)
/dev/mapper/coreos-luks-root-nocrypt on /dev/termination-log type xfs (rw,relatime,seclabel,attr2,inode64,prjquota)
tmpfs on /run/secrets type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
tmpfs on /run/secrets/kubernetes.io/serviceaccount type tmpfs (ro,relatime,seclabel)
proc on /proc/bus type proc (ro,relatime)
proc on /proc/fs type proc (ro,relatime)
proc on /proc/irq type proc (ro,relatime)
proc on /proc/sys type proc (ro,relatime)
proc on /proc/sysrq-trigger type proc (ro,relatime)
tmpfs on /proc/acpi type tmpfs (ro,relatime,context="system_u:object_r:container_file_t:s0:c182,c767")
tmpfs on /proc/kcore type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k,mode=755)
tmpfs on /proc/keys type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k,mode=755)
tmpfs on /proc/timer_list type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k,mode=755)
tmpfs on /proc/sched_debug type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k,mode=755)
tmpfs on /proc/scsi type tmpfs (ro,relatime,context="system_u:object_r:container_file_t:s0:c182,c767")
tmpfs on /sys/firmware type tmpfs (ro,relatime,context="system_u:object_r:container_file_t:s0:c182,c767")
tmpfs on /sys/fs/cgroup/systemd/release_agent type tmpfs (rw,nosuid,context="system_u:object_r:container_file_t:s0:c182,c767",size=65536k,mode=755)
```

## List of capabilities

Using this initContainer:

```yaml
    # https://stackoverflow.com/questions/43621959/how-can-i-find-out-which-capabilities-a-container-has-been-given
    - name: init-list-capabilities
      image: docker.io/alpine
      command:
        - sh
        - -c
        - 'apk add -U libcap; capsh --print'
```

### Default

```raw
Current: = cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot+eip
Bounding set =cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot
Ambient set =
Securebits: 00/0x0/1'b0
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
 secure-no-ambient-raise: no (unlocked)
uid=0(root)
gid=0(root)
groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)
```

- CAP_CHOWN
- CAP_DAC_OVERRIDE
- CAP_FOWNER
- CAP_FSETID
- CAP_KILL
- CAP_SETGID
- CAP_SETUID
- CAP_SETPCAP
- CAP_NET_BIND_SERVICE
- CAP_NET_RAW
- CAP_SYS_CHROOT

### privileged=true

```raw
Current: = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read+eip
Bounding set = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read
Ambient set = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,cap_audit_read
Securebits: 00/0x0/1'b0
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
 secure-no-ambient-raise: no (unlocked)
uid=0(root)
gid=0(root)
groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)
```

The default ones and append the following:

- CAP_DAC_READ_SEARCH
- CAP_LINUX_IMMUTABLE
- CAP_NET_BROADCAST
- CAP_NET_ADMIN
- CAP_IPC_LOCK
- CAP_IPC_OWNER
- CAP_SYS_MODULE
- CAP_SYS_RAWIO
- CAP_SYS_PTRACE
- CAP_SYS_PACCT
- CAP_SYS_ADMIN
- CAP_SYS_BOOT
- CAP_SYS_NICE
- CAP_SYS_RESOURCE
- CAP_SYS_TIME
- CAP_SYS_TTY_CONFIG
- CAP_MKNOD
- CAP_LEASE
- CAP_AUDIT_WRITE
- CAP_AUDIT_CONTROL
- CAP_SETFCAP
- CAP_MAC_OVERRIDE
- CAP_MAC_ADMIN
- CAP_SYSLOG
- CAP_WAKE_ALARM
- CAP_BLOCK_SUSPEND
- CAP_AUDIT_READ



### restricted





