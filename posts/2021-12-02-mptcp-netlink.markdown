---
title: Capture netlink communications
tags: mptcp
author: Matt
---

MPTCP on linux is implemented in kernel space. Working in kernelspace brings
some constraints (program in C, no libc etc). Most programs are way easier being
run in userspace where segfaults won't bring your OS down.
The protocol used to exchange data between userspace and kernelspace on linux is
called "netlink".

```
sudo ip link add nlmon0 type nlmon
sudo ip link set dev nlmon0 up
```



