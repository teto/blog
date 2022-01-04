---
title: Sharkd introduction (wireshark daemon)
tags: wireshark
author: Matt
---

[Wireshark][Wireshark] is the most famous packet capture/analysis software out
there.
Most of the times you use it interactively but there is a lesser known feature
to instrument wireshark somewhat (it is limited): **sharkd**, the wireshark daemon.

You can setup the daemon to listen on a unix socket:
```
sharkd unix:/tmp/sharkd
```
and send json requests to that socket.

The protocol used in sharkd was changed in wireshark 3.6 and as of this
writing, the [official documentation][sharkd-doc] has not been updated so refer
to the source (anything with sharkd in the name).
A bunch of 3.6 compatible requests are available in [mptcpanalyzer's contrib
folder](https://github.com/teto/mptcpanalyzer/tree/main/contrib).

You can run them via
```
cat analyze.json | socat UNIX-CONNECT:/tmp/sharkd.sock -
```

Note that in practice there are several pitfalls to avoid:
- the order of attributes in the json matters ! "method" has to come before
"params" see
[this post](https://ask.wireshark.org/question/25581/invalid-json-request-to-tshark/) for details.
- the requests have to be written on one line and finish with a newline to be
processed.


[Wireshark](www.wireshark.org) > 3.0 understands the MPTCP protocol and can
display the relative global sequence number (also called DSN: Data Sequence
Number).
sharkd-doc: https://wiki.wireshark.org/Development/sharkd#request-syntax
https://wiki.wireshark.org/sharkd-Request-Syntax.md



