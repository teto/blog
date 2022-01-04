---
title: Working with the MPTCP path manager
tags: mptcp
author: Matt
---

Multipath TCP (mptcp) is an extension of TCP (Transmission Control Protocol) to
transfer data over multiple paths.

On linux, MPTCP  is implemented in kernel space. Working in kernelspace brings
some constraints (program in C, no libc etc). Most programs are easier being
developed in userspace where segfaults won't bring your OS down.
Gladly, there is protocol called "netlink" to exchange data between userspace and kernelspace.
netlink is a TLV (type-length-value) protocol with different protocols built on
top of it such as this MPTCP path management protocol. 

These protocols are adhoc and usually not documented (apart from the source
code). That's where [wireshark][wireshark] comes in handy.

This capacity is leveraged by the [out-of-tree] linux MPTCP path manager.


You can install our plugin which appears in mptcp-pm contrib folder:
1. Download [mptcp plugin](github.com/teto/mptcpanalyzer/contrib/mptcp.lua).
2. Move it to ~/.config/wireshark/plugins

To test it is properl installed you can:
1. Download from the same repo an [example pcap](github.com/teto/mptcpanalyzer/mptcp-pm/contrib/netlink-mptcp.pcapng).
2. Load it in wireshark
3. Then you can filter for `genl.mptcp.cmd`

Even more interesting is the ability to diagnose these events live.

To achive this run:
```
sudo ip link add nlmon0 type nlmon
sudo ip link set dev nlmon0 up
```

a new interface "nlmon0" should appear in wireshark you can monitor from !

Cheers.

[out-of-tree]: http://mutipath-tcp.org
wireshark: www.wireshark.org
