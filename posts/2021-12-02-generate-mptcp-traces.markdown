---
title: Generate mptcp traces (with iperf)
tags: mptcp, pcap, iperf
author: Matt
---

See [this post](./2021-12-02-install-mptcp-kernel.markdown) for an MPTCP
introduction.


Let's generate some MPTCP packets that we can analyze with [mptcpanalyzer](https://github.com/teto/mptcpanalyzer/tree/main/mptcpanalyzer#installation).


`iperf -s` starts the iperf server, by default listens on port 5201 (can be
overriden with `-p`).

`iperf -c localhost --cport 2042 -n 20b`
`--cport` allows to specify the client port in advance, which allows us to filter
this connection in peculiar.

`multipath-tcp.org` runs an iperf server `-n` allows to limit the number of
bytes.

Remember that by default iperf sends data from client to the server.
This can be altered via `--bidir` to have it both ways or `--reverse`.

[Wireshark][Wireshark] > 3.0 understands the MPTCP protocol and can
display the relative global sequence number (also called DSN: Data Sequence
Number).



[Wireshark]: www.wireshark.org 
