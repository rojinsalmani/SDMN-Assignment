#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: sudo ./runtime.sh <hostname> [memory_limit_mb]"
    exit 1
fi

HOSTNAME=$1
MEM_LIMIT=$2

BASE_FS="/var/lib/mycontainer/ubuntu20.04"
CONTAINERS_DIR="/var/lib/mycontainer"
MY_FS="$CONTAINERS_DIR/$HOSTNAME"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "=> Setting up container: $HOSTNAME"

if [ ! -d "$MY_FS" ]; then
    echo "=> Cloning base Ubuntu 20.04 filesystem..."
    cp -a "$BASE_FS" "$MY_FS"
else
    echo "=> Filesystem for $HOSTNAME already exists."
fi

CGROUP_CMD=""
if [ -n "$MEM_LIMIT" ]; then
    echo "=> Setting memory limit to ${MEM_LIMIT}MB..."
    MEM_BYTES=$((MEM_LIMIT * 1024 * 1024))
    CGNAME="container_$HOSTNAME"
    
    cgcreate -g memory:$CGNAME
    cgset -r memory.limit_in_bytes=$MEM_BYTES $CGNAME 2>/dev/null || cgset -r memory.max=$MEM_BYTES $CGNAME
    
    CGROUP_CMD="cgexec -g memory:$CGNAME"
fi

cat << 'EOF' > "$MY_FS/.init.sh"
#!/bin/bash

hostname "$1"

mount -t proc proc /proc

echo "=> Inside container! Run 'ps fax' to see PID 1."

exec /bin/bash
EOF

chmod +x "$MY_FS/.init.sh"

echo "=> Starting container..."
$CGROUP_CMD unshare -p -f -n -u -m chroot "$MY_FS" /.init.sh "$HOSTNAME"

echo "=> Container exited. Cleaning up /proc..."
umount "$MY_FS/proc" 2>/dev/null
