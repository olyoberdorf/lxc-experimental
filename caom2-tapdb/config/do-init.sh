#!/bin/bash

LOG=/var/lib/pgsql/10/do-init.log
touch $LOG

echo -n "START: " >> $LOG
date >> $LOG

INITDB=0

if [ -e /var/lib/pgsql/10/data/postgresql.conf ]; then
    echo "do-init: detected existing setup... skipping database init" >> $LOG
else
    INITDB=1
fi

if [ $INITDB == 1 ]; then
    # change ownership of injected config files
    chown -R postgres.postgres /var/lib/pgsql/10/*
    su -l postgres -c '/bin/bash /var/lib/pgsql/10/init-postgres.sh' >> $LOG
fi

# configure server to start automatically
systemctl enable postgresql-10.service >> $LOG

# start server
systemctl start postgresql-10.service >> $LOG

if [ $INITDB == 1 ]; then
    # create standard user(s), database(s), schema(s)
    su -l postgres -c '/bin/bash /var/lib/pgsql/10/init-content.sh' >> $LOG
fi

echo -n "DONE: " >> $LOG
date >> $LOG

