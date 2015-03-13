#!/bin/bash
# This script will get the percent disk utilization of the /dummy mount from all defined build slaves

SERVERS=(server005 server006 server007 server008 server009 server010 server024 server025 server026 server027 server028 server029 server030 server031)
USER=user
TMPFILE=$(mktemp)


echo "Percent disk utilization for /dummy mount for Bamboo slaves:"
for i in "${SERVERS[@]}"
do
    line=$(ssh $USER@$i "df | grep /dummy")
    percent=$(echo $line | awk '{print $4}')
    echo $i $percent >> $TMPFILE
done

cat $TMPFILE | sort -rk 2
rm $TMPFILE
