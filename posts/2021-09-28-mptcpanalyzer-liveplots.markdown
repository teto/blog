---
title: Live plotting with mptcpanalyzer
tags: mptcpanalyzer, mptcp
author: Matt
---

Install the iperf3 with the multipath extension (for instance via
`nix profile install github:teto/mptcp-flake#iperf3-mptcp`).

1. Start the iperf server with `iperf -s`:
2. Run the following command in mptcpanalyzer: `plot-mptcp-live 127.0.0.1 127.0.0.1 2042 5201 client lo`
3. Start a MPTCP local transfer `iperf -c localhost --cport 2042 -n20k -4 -m`



[mptcpanalyzer]: https://github.com/ngi-mptcp/mptcpanalyzer/mptcpanalyzer

