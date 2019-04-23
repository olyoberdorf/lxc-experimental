#!/bin/bash

. ../wait-for-network.sh

IMG=base-astrodb
IMGFILE=${IMG}.tar.gz
CTR=tmp-$(uuidgen)

## create cadc-astrodb database container
lxc list $CTR | grep -q $CTR
if [ $? == 0 ]; then
	echo "found: $CTR"
else
	lxc init images:centos/7 $CTR
	echo "created: $CTR"
fi

# must be running to install and configure
echo "starting $CTR ..."
lxc start $CTR

waitForNetwork $CTR

echo "adding yum repos..."
lxc exec $CTR -- yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
lxc exec $CTR -- yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
lxc file push cadc.repo $CTR/etc/yum.repos.d/

echo "updating $CTR ..."
lxc exec $CTR -- yum -y update

echo "installing PG packages..."
lxc exec $CTR -- yum -y install postgresql10-server postgresql10-contrib pgsphere10

lxc exec $CTR -- yum clean all

#echo "stopping $CTR ..."
lxc stop $CTR

## publish container as a new image in local image store
echo "publishing $CTR ..."
lxc publish $CTR --alias $IMG description="Centos 7 amd64 / PG 10"
#lxc delete $CTR
echo "published: $IMG"



