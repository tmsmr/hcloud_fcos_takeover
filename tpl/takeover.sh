#!/bin/bash

IGNITION_CONFIG=${ignition_config_path}
INSTALL_DEVICE=${install_device}

KERNEL_ARCH=$(uname -m)
INITRAMFS_GLOB="fedora-coreos-*-live-initramfs.$KERNEL_ARCH.img"
ROOTFS_GLOB="fedora-coreos-*-live-rootfs.$KERNEL_ARCH.img"
KERNEL_GLOB="fedora-coreos-*-live-kernel.$KERNEL_ARCH"

set -eux -o pipefail

dnf install -y kexec-tools coreos-installer

coreos-installer download -f pxe

coreos-installer pxe customize \
  --dest-device $INSTALL_DEVICE \
  --dest-ignition $IGNITION_CONFIG \
  -o custom-initramfs.img $INITRAMFS_GLOB

cat custom-initramfs.img $ROOTFS_GLOB > fcos-combined.img

kexec -l $KERNEL_GLOB \
  --initrd=fcos-combined.img \
  --command-line="ignition.firstboot ignition.platform.id=qemu console=ttyS0"
systemctl kexec
