---
title: Analyze mptcp packet captures with mptcpanalyzer
tags: mptcp, mptcpanalyzer
author: Matt
---

See [my other post](./2021-12-02-install-mptcp-kernel.markdown) for an introduction of MPTCP.
Even though it is an extension of TCP, the changes are deep enough that it could
be considered a new protocol.
[How to install MPTCP on linux](posts/2021-12-02-install-mptcp-kernel.markdown)

Follow [mptcpanalyzer's README](https://github.com/teto/mptcpanalyzer/tree/main/mptcpanalyzer#installation) instructions
to install the software.

First we need some pcaps, you can either [capture some traffic
yourself](posts/2021-12-02-generate-mptcp-traces.markdown), or download some PCAPs from either the [wireshark wiki](https://wiki.wireshark.org/SampleCaptures#MPTCP) or [mptcpanalyzer examples](https://github.com/teto/mptcpanalyzer/tree/main/mptcpanalyzer/examples).


Start `mptcpanalyzer` then load the pcap with:
```
load-pcap examples/client_2_filtered.pcapng
```

`help` shows you the available commands.

To inspect at high level the pcap, run:
```
list-tcp
```
to list tcp connections.

Similarly you can list mptcp-sessions:
```
examples/client_2_filtered.pcapng> list-mptcp
Number of MPTCP connections 2
[StreamId 0,StreamId 1]
Server key/token: 10048458395084872514/2846245513
Client key/token: 17227928701987094984/4093186044

Subflows:
10.0.0.1:33782 -> 10.0.0.2:5201 (tcp.stream: 0)
10.0.0.1:54595 -> 11.0.0.2:5201 (tcp.stream: 2)
11.0.0.1:35589 -> 10.0.0.2:5201 (tcp.stream: 6)
11.0.0.1:59555 -> 11.0.0.2:5201 (tcp.stream: 4)

Server key/token: 14803550490012999960/1015310287
Client key/token: 2708191410426849018/3188734930

Subflows:
10.0.0.1:33784 -> 10.0.0.2:5201 (tcp.stream: 1)
10.0.0.1:57491 -> 11.0.0.2:5201 (tcp.stream: 3)
11.0.0.1:50007 -> 10.0.0.2:5201 (tcp.stream: 7)
11.0.0.1:50077 -> 11.0.0.2:5201 (tcp.stream: 5)
```

To examine deeper a communication:
```
examples/client_2_filtered.pcapng> mptcp-summary --full 0
[info]  [Main#657] Running ["mptcp-summary","--full","0"]
Server key/token: 10048458395084872514/2846245513
Client key/token: 17227928701987094984/4093186044

Subflows:
10.0.0.1:33782 -> 10.0.0.2:5201 (tcp.stream: 0)
10.0.0.1:54595 -> 11.0.0.2:5201 (tcp.stream: 2)
11.0.0.1:35589 -> 10.0.0.2:5201 (tcp.stream: 6)
11.0.0.1:59555 -> 11.0.0.2:5201 (tcp.stream: 4)

[debug] [M.C.List#286] Number of rows 4164
 Mptcp stats towards RoleClient :
- Duration (50.869754285s,Timestamp 0.0,Timestamp 50.869754285)
- Goodput 3.1649455017610375
<TODO>

Applicative Bytes : 161
Subflow stats:
stream StreamId 0: transferred 308.0 out of 161 between 5.211195538 end time: 50.869754285 , accouting for 1.9130434782608696 %
stream StreamId 2: transferred 0.0 out of 161 between 6.235584666 end time: 50.803757013 , accouting for 0.0 %
stream StreamId 6: transferred 0.0 out of 161 between 7.943047833 end time: 45.887953648999996 , accouting for 0.0 %
stream StreamId 4: transferred 4.294967295e9 out of 161 between 0.0 end time: 0.0 , accouting for 2.667681549689441e7 %
```
