#!/usr/bin/env bash

# to be filled by terraform
IGNITION_CONFIG=${ignition_config_path}
INSTALL_DEVICE=${install_device}
HCLOUD_CONSOLE=${hcloud_console}

# file names to match later on
KERNEL_ARCH=$(uname -m)
INITRAMFS_GLOB="fedora-coreos-*-live-initramfs.$KERNEL_ARCH.img"
ROOTFS_GLOB="fedora-coreos-*-live-rootfs.$KERNEL_ARCH.img"
KERNEL_GLOB="fedora-coreos-*-live-kernel.$KERNEL_ARCH"

# wait until internet connection is up
until ping -c 1 -w 1 1.1.1.1 > /dev/null; do
    echo "no internet connection"
    sleep 1
done

set -eux -o pipefail

dnf install -y kexec-tools coreos-installer

# download fcos pxe installer
coreos-installer download -f pxe

# embed config in initramfs
coreos-installer pxe customize \
  --dest-device $INSTALL_DEVICE \
  --dest-ignition $IGNITION_CONFIG \
  -o custom-initramfs.img $INITRAMFS_GLOB

# combine initrd/rootfs
cat custom-initramfs.img $ROOTFS_GLOB > fcos-combined.img

# load into ram and kexec
kexec -l $KERNEL_GLOB \
  --initrd=fcos-combined.img \
  --command-line="ignition.firstboot ignition.platform.id=qemu console=$HCLOUD_CONSOLE"
systemctl kexec
