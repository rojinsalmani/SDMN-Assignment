# Figure 2: Routing Without a Router Namespace

When the dedicated router namespace is removed, we can use the **root namespace (the host machine itself)** to route packets between the two subnets. 

Here is how the packets can be routed:

1. **IP Assignment on Bridges:** Instead of relying on a router namespace, the gateway IP addresses are assigned directly to the bridge interfaces in the root namespace.
   * `172.0.0.1/24` is assigned to `br1`.
   * `10.10.0.1/24` is assigned to `br2`.
2. **IP Forwarding:** IP forwarding must be enabled on the host machine to allow the Linux kernel to route packets between its network interfaces (`sysctl -w net.ipv4.ip_forward=1`).
3. **Routing Process:** Because both `br1` and `br2` exist in the root namespace, the host's local routing table will automatically have connected routes for both the `172.0.0.0/24` and `10.10.0.0/24` subnets. 
4. **Packet Flow:** When a node in subnet A sends a packet to subnet B, it hits the bridge (its default gateway). The root namespace consults its routing table, sees the destination subnet is directly reachable via the other bridge, and forwards the packet accordingly.
