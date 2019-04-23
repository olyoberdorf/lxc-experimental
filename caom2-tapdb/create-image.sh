#!/bin/bash

. ../wait-for-network.sh

BASEIMG=base-astrodb
IMG=tapdb
IMGFILE=${IMG}.tar.gz
CTR=tmp-$(uuidgen)


echo "create $CTR from $BASEIMG"
lxc init $BASEIMG $CTR
lxc start $CTR

waitForNetwork $CTR

echo "inject PostgreSQL configuration files into container"
for cf in config/*.*; do 
    lxc file push $cf $CTR/var/lib/pgsql/10/
done

echo "inject systemd unit to perform init at next boot"
lxc file push pgdb-init.service $CTR/usr/lib/systemd/system/
lxc exec $CTR systemctl enable pgdb-init.service

echo "stop $CTR ..."
lxc stop $CTR

echo "publish $CTR ..."
lxc publish $CTR --alias $IMG description="base-astrodb + TAP db-init"
lxc delete $CTR

