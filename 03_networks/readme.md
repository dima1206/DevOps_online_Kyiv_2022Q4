- [Schema, VirtualBox, router](#schema-virtualbox-router)
- [Initial configurations (1-3)](#initial-configurations-1-3)
  * [Server, DHCP](#server-dhcp)
  * [Client1](#client1)
  * [Client2](#client2)
  * [Check connection with explanations](#check-connection-with-explanations)
- [Loopback on client1 (4-5)](#loopback-on-client1-4-5)
  * [`lo` interface](#lo-interface)
  * [Routing](#routing)
  * [Summarizing address](#summarizing-address)
- [SSH (6)](#ssh-6)
- [Firewall (7)](#firewall-7)
- [NAT (8)](#nat-8)

## Schema, VirtualBox, router

client1 - CentOS, client2 - Ubuntu, server1 - Ubuntu.

Schema:

![](./images/network.drawio.png)

VirtualBox network configurations:

![](./images/1.png)

![](./images/2.png)

![](./images/3.png)

Router configuration:

![](./images/0.png)

## Initial configurations (1-3)

### Server, DHCP

Interfaces on server1:

![](./images/4.png)

<details><summary>Config file for netplan</summary>

![](./images/5.png)
</details>

For DHCP server I installed `isc-dhcp-server` and configured it:

![](./images/6.png)

![](./images/7.png)

Allow forwarding:

![](./images/8.png)

### Client1

Interfaces on client1:

![](./images/9.png)

<details><summary>Config files</summary>

![](./images/10.png)

![](./images/11.png)
</details>

### Client2

Interfaces on client2:

![](./images/13.png)

<details><summary>Config file</summary>

![](./images/14.png)
</details>

### Check connection with explanations

From client1 to client2:

![](./images/15.png)

Explanation: Since client1 doesn't know anything about net3 (10.6.99.0/24), it sends packets to gateway (server1). Server knows about net3 and forwards the packets. And since client1 does know about net4, it sends packets directly to client2.

From client2 to client1:

![](./images/16.png)

Explanation: it's pretty much the same as above, just reversed. But in this case using `-I` option to use ICMP echo requests, since default UDP probes are blocked by CentOS's firewall.

Access to Internet from client1:

![](./images/18.png)

Explanation: Since client1 doesn't know anything about 8.8.8.8, it sends the packets to gateway (server1). server1 doesn't know abut 8.8.8.8 as well, so it forwards the packets to its own gateway - my router. My router forwards them to its own gateway (my ISP). When packets with reply arrive from my ISP, my router finds the records that I added to its routing table and forwards the packets to server1. server1 knows about net2 and forwards packets directly to client1.

Access to Internet from client2:

![](./images/17.png)

Explanation: The same as above, but client2 instead of client1 and net3 instead of net2.

## Loopback on client1 (4-5)

### `lo` interface

![](./images/20.png)

<details><summary>Config files</summary>

![](./images/19.png)
</details>

### Routing

Routing table on server1:

![](./images/22.png)

<details><summary>Config file</summary>

![](./images/21.png)
</details>

Routing table on client2:

![](./images/24.png)

<details><summary>Config file</summary>

![](./images/23.png)
</details>

Check connection from client2 to client1's `lo` interface:

![](./images/25.png)

### Summarizing address

Summarizing network address with longest prefix for `172.17.22.1/24` and `172.17.32.1/24` is `172.17.0.0/18`.

New routing table on server1:

![](./images/26.png)

<details><summary>Config file</summary>

![](./images/27.png)
</details>

New routing table on client2:

![](./images/28.png)

<details><summary>Config file</summary>

![](./images/29.png)
</details>

Check connection from client2 to client1's `lo` interface with new routing tables (both addresses are accessed via server1):

![](./images/30.png)

## SSH (6)

I already have configured SSH and using it to access VMs.

<details><summary>Make sure that SSH works</summary>

SSH from client1:

![](./images/31.png)

SSH from client2:

![](./images/32.png)
</details>

## Firewall (7)

I directly used `iptables` to configure the rules:

![](./images/33.png)

<details><summary>Check if firewall works properly</summary>

SSH from client**1**:

![](./images/34.png)

SSH from client**2**:

![](./images/35.png)

Ping from client2 to 172.17.**22**.1 (client1):

![](./images/36.png)

Ping from client2 to 172.17.**32**.1 (client1):

![](./images/37.png)
</details>

## NAT (8)

Remove custom routing from router:

![](./images/38.png)

Add masquerading on server1:

![](./images/39.png)

Check connection from client1:

![](./images/40.png)

Check connection from client2:

![](./images/41.png)

I also installed `iptables-persistent` on server1 to automatically load all the rules at startup from /etc/iptables/[rules.v4](./rules.v4).