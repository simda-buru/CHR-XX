#!/bin/bash

# Variables
version="nil"
vmID="nil"

echo "############## Start of Script ##############"

echo "## Checking unzip and jq (json query) package is available..."

if [ $(dpkg -l | awk "/$1/ {print }"|wc -l) -ge 1 ]; then
        echo "Package unzip telah terinstalasi di Proxmox!"
else
        echo "Melakukan instalasi package unzip di Proxmox!"
        sudo apt update
        sudo apt -y install unzip
fi

if [ $(dpkg -l | awk "/$1/ {print }"|wc -l) -ge 1 ]; then
        echo "Package jq telah terinstalasi di Proxmox!"
else
        echo "Melakukan instalasi package jq di Proxmox!"
        sudo apt update
        sudo apt -y install jq
fi

echo "## Checking if temp dir is available..."

if [ -d /root/temp ]; then
    echo "-- Directory exists!"
else
    echo "-- Creating temp dir!"
    mkdir /root/temp
fi

# Ask user for version
echo "## Preparing for image download and VM creation!"
read -p "Please input CHR version to deploy (e.g. 6.38.2, 6.40.1, 7.18.2): " version

# Check if image is already downloaded
if [ -f /root/temp/chr-$version-legacy-bios.img ]; then
    echo "-- CHR image is available."
else
    echo "-- Downloading CHR $version image file."
    cd /root/temp
    echo "---------------------------------------------------------------------------"
    # wget https://download.mikrotik.com/routeros/$version/chr-$version.img.zip
    # wget https://github.com/elseif/MikroTikPatch/releases/download/$version/chr-$version.img.zip
    wget https://github.com/elseif/MikroTikPatch/releases/download/$version/chr-$version-legacy-bios.img.zip
    unzip chr-$version-legacy-bios.img.zip
    qemu-img resize -f raw chr-$ver-legacy-bios.img 256M
    echo "---------------------------------------------------------------------------"
fi

# List existing VMs and ask for new VM ID
echo "== Printing list of VM's and CT's on this hypervisor!"
qm list
echo ""
pct list
echo ""
read -p "Please Enter a free VM ID to use: " vmID
echo ""

# Convert image to QCOW2
echo "-- Converting image to qcow2 format..."
qemu-img convert \
    -f raw \
    -O qcow2 \
    /root/temp/chr-$version-legacy-bios.img \
    /root/temp/chr-$version.qcow2

# Create minimal VM
echo "-- Creating CHR VM with ID $vmID"
qm create $vmID \
  --name CHR-$version \
  --net0 virtio,bridge=vmbr0 \
  --bootdisk virtio0 \
  --ostype l26 \
  --memory 512 \
  --onboot no \
  --sockets 1 \
  --cores 1

# Import disk to local-lvm
echo "-- Importing disk to local-lvm..."
qm importdisk $vmID /root/temp/chr-$version.qcow2 local-lvm --format qcow2

# Attach imported disk as virtio0
echo "-- Attaching disk to VM..."
qm set $vmID --virtio0 local-lvm:vm-$vmID-disk-0

# Set boot order
echo "-- Setting boot order to virtio0..."
qm set $vmID --boot order=virtio0

echo "############## End of Script ##############"
