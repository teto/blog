---
title: Working with the MPTCP path manager
tags: mptcp
author: Matt
---

MPTCP on linux is implemented in kernel space. Working in kernelspace brings
some constraints (program in C, no libc etc). Most programs are easier being
developed in userspace where segfaults won't bring your OS down.
Gladly, there is protocol called "netlink" to exchange data between userspace and kernelspace.

This capacity is leveraged by the [out-of-tree] linux MPTCP path manager.

```
sudo ip link add nlmon0 type nlmon
sudo ip link set dev nlmon0 up
```

The forked MPTCP 

[out-of-tree]:
