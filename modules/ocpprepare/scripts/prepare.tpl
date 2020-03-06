#!/bin/bash
set -e

openshift_version_number=3.11
ansible_version=2.6

echo "vm.max_map_count = 262144" | sudo tee --append /etc/sysctl.conf > /dev/null
#sudo sysctl -p

#sudo subscription-manager clean
#sudo subscription-manager register --username=${rhel_user_name} --password=${rhel_password} --force
#sudo subscription-manager refresh
#for pool in ${subscription_pool_list}; do
#  sudo subscription-manager attach --pool=$pool
#done
#sudo subscription-manager repos --disable="*"

#if [ $(arch) == 'ppc64le' ]; then
#sudo subscription-manager repos \
 #   --enable="rhel-7-for-power-le-rpms" \
  #  --enable="rhel-7-for-power-le-extras-rpms" \
   # --enable="rhel-7-for-power-le-optional-rpms" \
    #--enable="rhel-7-server-ansible-$ansible_version-for-power-le-rpms" \
    #--enable="rhel-7-for-power-le-ose-$openshift_version_number-rpms" \
    #--enable="rhel-7-for-power-le-fast-datapath-rpms" \
    #--enable="rhel-7-server-for-power-le-rhscl-rpms"
#else
#sudo subscription-manager repos \
 # --enable="rhel-7-server-rpms" \
  #--enable="rhel-7-server-extras-rpms" \
  #--enable="rhel-7-fast-datapath-rpms" \
  #--enable="rhel-7-server-ansible-$ansible_version-rpms" \
  #--enable="rhel-7-server-ose-$openshift_version_number-rpms"
#fi

sudo rm -fr /var/cache/yum/*
sudo yum clean all
sudo yum update -y --skip-broken

sudo yum install -y wget git net-tools bind-utils iptables-services python-firewall bridge-utils bash-completion kexec-tools sos psacct lvm2* httpd-tools vim
sudo yum install -y openshift-ansible

sudo yum remove -y docker-ce docker docker-engine docker.io
sudo yum install -y docker-1.13.1
sudo groupadd -f docker
sudo usermod -aG docker $USER
# configure docker to control the size of the container logs
sudo sed -i.bak "s/OPTIONS='--selinux-enabled --log-driver=journald --signature-verification=false'/OPTIONS='--signature-verification=false --insecure-registry=172.30.0.0\/16 --log-opt max-size=1M --log-opt max-file=3 --disable-legacy-registry=true'/" /etc/sysconfig/docker
sudo systemctl enable docker
sudo systemctl stop docker
sudo rm -rf /var/lib/docker/*
#
# From ==> https://docs.openshift.com/container-platform/3.11/install/host_preparation.html#installing-docker
# (OverlayFS with ThinPool storage on a separate block storage device)
# this storage was allocated and attached to the VSIs during the VSI create step
# Since additional block devices may be added in the future -- we cannot hardcode/assume the device name of the docker storage. We will scan for the storage
# searching on it by size.  The assumption is the user will specify a unique size for the volume, for example 101 Gig
# utilize the "docker-storage-setup" utility
#
# ... build the docker-storage-setup file 
sudo echo "STORAGE_DRIVER=overlay2" > /etc/sysconfig/docker-storage-setup
# start building the  device sstring ..
aaa="DEVS=/dev/"
# pick up the line with a volume in size equal to the docker volume size.  In case it's already partitioned (from a previous run) ... only pick up the first line 
# of the output (head -n 1) .   
aaa+=$(lsblk | grep ${docker_volume_size}G | cut -b 1-3 | head -n 1)
sudo echo "$aaa" >> /etc/sysconfig/docker-storage-setup
sudo echo "VG=docker-vg"  >> /etc/sysconfig/docker-storage-setup
# Wipe the disk just in case there was a partition left on there from a previous TF run
# pick up just the /dev/vdx device name
bbb="of=" 
bbb+=$(echo $aaa | cut -b 6-13)
sudo dd if=/dev/zero  "$bbb"  bs=512 count=1 
#
#  now run the command that does the setup (unfortunately it's named the same as the input file)
# this command will fail (and not do the necessary setup) if it finds an existing partition on the disk
sudo /usr/bin/docker-storage-setup
# dump out the report  for diagnostic purposes 
sudo cat /etc/sysconfig/docker-storage     
# restarting Docker with the new storage configuration
sudo rm -rf /var/lib/docker/*
sudo systemctl restart docker
sudo systemctl is-active docker
sudo systemctl enable NetworkManager 
sudo systemctl start NetworkManager
sudo chattr -i /etc/resolv.conf
echo NM_CONTROLLED=yes | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth0
echo PEERDNS=yes | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth0
echo "Enabling SELinux..."
# Permanent - on next reboot
sudo sed -i 's/^SELINUX=.*$/SELINUX=enforcing/g' /etc/selinux/config >& /dev/null
sudo sed -i 's/^SELINUXTYPE=.*$/SELINUXTYPE=targeted/g' /etc/selinux/config >& /dev/null
