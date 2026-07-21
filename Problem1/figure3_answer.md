# Figure 3: Routing Across Different Servers

When the namespaces are split across two different servers (Server 1 and Server 2) connected via a layer 2 switch, the root namespaces of both servers must act as routers for their local subnets.

Here is the solution to route packets between them:

1. **Physical IP Configuration:** Both Server 1 and Server 2 must have IP addresses on their physical network interfaces connected to the switch (e.g., `192.168.1.1` for Server 1 and `192.168.1.2` for Server 2).
2. **Gateway Assignment:** The gateway IP for each subnet is assigned to the respective bridge on that server.
   * On Server 1: `br1` gets `172.0.0.1/24`.
   * On Server 2: `br2` gets `10.10.0.1/24`.
3. **Enable IP Forwarding:** Both servers must have IP forwarding enabled (`sysctl -w net.ipv4.ip_forward=1`) so they can pass traffic between their internal bridge and their physical interface.
4. **Static Routing Rules:** Each server needs a static route to know where the other subnet lives:
   * **On Server 1:** Add a route directing traffic for `10.10.0.0/24` to Server 2's physical IP.
   * **On Server 2:** Add a route directing traffic for `172.0.0.0/24` to Server 1's physical IP.
5. **Packet Flow:** A packet leaving Node 1 reaches `br1`. Server 1's routing table directs it out the physical interface to Server 2. Server 2 receives it, checks its routing table, and forwards it to `br2`, where it is delivered to the destination node.
