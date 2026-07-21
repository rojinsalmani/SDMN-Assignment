#!/bin/bash

echo "Creating Network Namespaces"
ip netns add node1
ip netns add node2
ip netns add node3
ip netns add node4
ip netns add router

echo "Creating Bridges in the Root Namespace"
ip link add br1 type bridge
ip link add br2 type bridge
ip link set br1 up
ip link set br2 up

setup_node() {
    local ns_name=$1
    local br_name=$2
    local ip_addr=$3
    local veth_ns="${ns_name}-veth"
    local veth_br="${ns_name}-${br_name}"


    ip link add $veth_ns type veth peer name $veth_br
    
    ip link set $veth_ns netns $ns_name
    ip link set $veth_br master $br_name
    
    ip link set $veth_br up
    
    ip netns exec $ns_name ip addr add $ip_addr dev $veth_ns
    ip netns exec $ns_name ip link set $veth_ns up
    ip netns exec $ns_name ip link set lo up
}

echo "Connecting Nodes and Router to Bridges"
setup_node node1 br1 172.0.0.2/24
setup_node node2 br1 172.0.0.3/24
setup_node router br1 172.0.0.1/24

ip link add router-veth2 type veth peer name router-br2
ip link set router-veth2 netns router
ip link set router-br2 master br2
ip link set router-br2 up
ip netns exec router ip addr add 10.10.0.1/24 dev router-veth2
ip netns exec router ip link set router-veth2 up

setup_node node3 br2 10.10.0.2/24
setup_node node4 br2 10.10.0.3/24

echo "Configuring Routing and Forwarding"
ip netns exec router sysctl -w net.ipv4.ip_forward=1


ip netns exec node1 ip route add default via 172.0.0.1
ip netns exec node2 ip route add default via 172.0.0.1
ip netns exec node3 ip route add default via 10.10.0.1
ip netns exec node4 ip route add default via 10.10.0.1

echo "Topology creation complete!"
