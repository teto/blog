---
title: Install a Multipath TCP kernel on linux
tags: mptcp, kernel
author: Matt
---

Multipath TCP (mptcp) is an extension of TCP (Transmission Control Protocol) to
transfer data over multiple paths. This can be useful to download faster, make
it harder to spy on your traffic or just for fiability/redundancy.

Even though it is an extension of TCP, the changes are deep enough that it could
be considered a new protocol.

Nowadays there are two linux implementations that I know of:
1. the [legacy][out-of-tree] one developed at UCL (Belgium)
2. recent linux kernel (>= 5.13) also support basic MPTCP and add features with every new release.

Instructions to install 1) are available on their website so let's focus on the
official kernel.

Linux later than 5.13 contain MPTCP if it was enabled at compilation time.
You can also control the behavior at runtime: `sysctl -a |grep mptcp` should return something
similar to:
```sh
net.ipv4.tcp_available_ulp = mptcp
net.mptcp.add_addr_timeout = 120
net.mptcp.allow_join_initial_addr_port = 1
net.mptcp.checksum_enabled = 0
net.mptcp.enabled = 1      # <- at least this one !
```
if it doesn't check your kernel config, for instance with `zgrep MPTCP /proc/config.gz`.
On a nixos 5.14.12 kernel, I get:
```
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_MPTCP_KUNIT_TEST=m
```

Recompile your kernel with these options enabled and rebooting should fix it.

[out-of-tree]: http://mutipath-tcp.org
