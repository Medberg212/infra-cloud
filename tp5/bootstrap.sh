#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

# Update the package repository
sudo apt update

# Install necessary packages
sudo apt install -y apache2 awscli libapache2-mod-php mysql-client nfs-common php php-cli php-common php-curl php-fpm php-gd php-imap php-mbstring php-mysql php-redis php-xml php-zip unzip

# Create the mount point for the EFS file system
sudo mkdir -p /mnt/efs

# Mount the EFS file system
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /mnt/efs

# Add the EFS mount to /etc/fstab to mount it automatically at boot
echo '${efs_dns}:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0' | sudo tee -a /etc/fstab