# SELinux VM Fix

## Problem
Getting AVC denials when running VMs with virtiofsd filesystem sharing.

## Solution

### 1. Enable FUSE filesystem access for virtualization
```bash
sudo setsebool -P virt_use_fusefs on
```

### 2. Create custom policy for virtiofsd pipe communication
```bash
# Generate policy from AVC denials
sudo ausearch -m avc -ts today | grep virtiofsd | audit2allow -M virtiofsd_pipes

# Install the policy module
sudo semodule -i virtiofsd_pipes.pp
```

## What the policy allows
Allows `virtqemud_t` (virtiofsd) to read/write/getattr on pipes belonging to `svirt_t` (VM processes) for inter-process communication.

## Verify
```bash
# Check policy is installed
sudo semodule -l | grep virtiofsd

# Check for remaining denials
sudo ausearch -m avc -ts recent | grep virtqemud
```
