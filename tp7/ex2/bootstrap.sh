#!/bin/bash
sudo yum -y install amazon-efs-utils
sudo yum -y install python3-pip
sudo pip3 install botocore --upgrade
sudo mkdir /mnt/efs
fs_id="${fs_id}"
sudo mount -t efs -o tls $fs_id:/ /mnt/efs