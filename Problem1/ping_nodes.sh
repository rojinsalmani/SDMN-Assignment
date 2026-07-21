#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_node> <target_node>"
    echo "Example: $0 node1 router"
    exit 1
fi

SRC_NODE=$1
TARGET_NODE=$2

declare -A NODE_IPS=(
    ["node1"]="172.0.0.2"
    ["node2"]="172.0.0.3"
    ["router"]="172.0.0.1"
    ["node3"]="10.10.0.2"
    ["node4"]="10.10.0.3"
)

TARGET_IP=${NODE_IPS[$TARGET_NODE]}

if [ -z "$TARGET_IP" ]; then
    echo "Error: Unknown target node '$TARGET_NODE'."
    exit 1
fi

echo "Pinging $TARGET_NODE ($TARGET_IP) from $SRC_NODE"
ip netns exec $SRC_NODE ping -c 4 $TARGET_IP
