---
title: Analyze MPTCP reinjections with mptcpanalyzer
tags: mptcp, mptcpanalyzer
author: Matt
---

Multipath TCP can retransmit segments over different paths.
This can be useful in various scenarii:

* to remove head of line blocking at the MPTCP level
* in case the goal is to deliver information as fast as possible, one may want
to replicate the data across all subflows

Retransmitting information can both improve and decrease (in case of bottleneck) performance.
Thus we need to elaborate a framework to evaluate heuristics as when to
retransmit data.

As a first step, one can list reinjections (directly taken from wireshark analysis):
```
examples/client_2_filtered.pcapng> list-reinjections 1
packetid=757 (tcp.stream StreamId 1)
- Reinjection of 256(tcp.stream StreamId 7)
packetid=759 (tcp.stream StreamId 1)
- Reinjection of 257(tcp.stream StreamId 7)
packetid=775 (tcp.stream StreamId 7)
- Reinjection of 762(tcp.stream StreamId 1)
packetid=776 (tcp.stream StreamId 1)
- Reinjection of 259(tcp.stream StreamId 7)
```


To check whether a retransmission was effective or not, you have to be able to collect the data 
on both client and server and map the MPTCP streams [as explained in this post](./2022-01-02-mptcpanalyzer-one-way-delay-plots.markdown).

You can then call the 'analyze' command to get a deeper understanding:

```
> analyze examples/client_2_filtered.pcapng 0 examples/server_2_filtered.pcapng 0
Size after conversion to sender/receiver 47( 47)
Qualify reinjections for dests RoleServer
Number of reinjected packets: 3
4047
4048 is a reinjection of packet id 4047
number of original packets 1 Host RoleServer
Redundant reinjection3.9522647857666016e-3
4155
4156 is a reinjection of packet id 4155
number of original packets 1 Host RoleServer
Redundant reinjection1.430511474609375e-6
4155
4157 is a reinjection of packet id 4155
number of original packets 1 Host RoleServer
Redundant reinjection1.856053352355957
```

[mptcpanalyzer][mptcpanalyzer] has a unique capability where it can

[mptcpanalyzer]: https://github.com/ngi-mptcp/mptcpanalyzer/mptcpanalyzer

