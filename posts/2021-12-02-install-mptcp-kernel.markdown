---
title: Install a Multipath TCP kernel on linux
tags: mptcp
author: Matt
draft: true
---

Multipath TCP (mptcp) is an extension of TCP (Transmission Control Protocol) to
transfer data over multiple paths. This can be useful to download faster, make
it harder to spy on your traffic or just for fiability/redundancy.

Even though it is an extension of TCP, the changes are deep enough that it could
be considered a new protocol.

Linux later than 5.30 contain MPTCP if it was enabled at runtime.
You can check this with `sysctl -a |grep mptcp` which can return something
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

[Wireshark](www.wireshark.org) > 3.0 understands the MPTCP protocol and can
display the relative global sequence number (also called DSN: Data Sequence
Number).

