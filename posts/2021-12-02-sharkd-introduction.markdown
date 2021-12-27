---
title: Sharkd introduction (wireshark daemon)
tags: wireshark
author: Matt
draft: true
---

[Wireshark][Wireshark] is the most famous packet capture/analysis software out
there.
Most of the times you use it interactively but there is a lesser known feature
to instrument wireshark somewhat (it is limited): **sharkd**, the wireshark
							daemon.

You can setup the daemon to listen on a unix socket:
```
sharkd unix:/tmp/sharkd
```
and send requests to that socket
```
```
https://wiki.wireshark.org/Development/sharkd#request-syntax
https://wiki.wireshark.org/sharkd-Request-Syntax.md

[Wireshark](www.wireshark.org) > 3.0 understands the MPTCP protocol and can
display the relative global sequence number (also called DSN: Data Sequence
Number).



