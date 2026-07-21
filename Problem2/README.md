# Problem 2: Custom Container Runtime

Hey there! This is my solution for the container runtime assignment (Problem 2). I wrote a CLI script in Bash called `runtime.sh` that mimics Docker's basic behavior using Linux namespaces and `chroot`. 

## Prerequisites
Before running the script, make sure the Ubuntu 20.04 base filesystem is downloaded. If you ran my setup script from problem 1, it should already be securely located at `/var/lib/mycontainer/ubuntu20.04`.

## How to run the CLI

The script requires `sudo` because creating Linux namespaces and using `chroot` strictly requires root privileges. 

### 1. Basic Container (Required Features)
To start a container, just pass the hostname you want to use as the first parameter:

```bash
sudo ./runtime.sh myhostname
