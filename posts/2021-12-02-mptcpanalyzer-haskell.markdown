---
title: Analyze mptcp packet captures with mptcpanalyzer
tags: mptcp
author: Matt
draft: true
---

Multipath TCP (mptcp) is an extension of TCP (Transmission Control Protocol) to
transfer data over multiple paths. This can be useful to download faster, make
it harder to spy on your traffic or just for fiability/redundancy.

Even though it is an extension of TCP, the changes are deep enough that it could
be considered a new protocol.
[How to install MPTCP on linux](posts/2021-12-02-install-mptcp-kernel.markdown)


Let's generate some MPTCP packets that we can analyze with [mptcpanalyzer](https://github.com/teto/quantum2).
Follow the installation instructions.
(if you use nix, `nix-env -iA haskellPackages.mptcpanalyzer` could also do the
 trick).


`iperf -s` starts the iperf server, by default listens on port 5201 (can be
overriden with `-p`).

`iperf -c localhost --cport 2042 -n 20b`
`--cport` allows to specify the client port in advance, which allows us to filter
this connection in peculiar.

`multipath-tcp.org` runs an iperf server `-n` allows to limit the number of
bytes.

Remember that by default iperf sends data from client to the server.
This can be altered via `--bidir` to have it both ways or `--reverse`.

[Wireshark](www.wireshark.org) > 3.0 understands the MPTCP protocol and can
display the relative global sequence number (also called DSN: Data Sequence
Number).
