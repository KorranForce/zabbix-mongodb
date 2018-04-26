#!/bin/bash

# Date:                 22/01/2017
# Author:               Long Chen
# Description:          A script to send MongoDB stats to zabbix server by using zabbix sender
# Requires:             Zabbix Sender, zabbix-mongodb.py

# Send the results to zabbix server by using zabbix sender
python /usr/local/bin/zabbix-mongodb.py > /var/tmp/mongo_zabbix.items
result=$(/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -i /var/tmp/mongo_zabbix.items 2>&1)
response=$(echo "$result" | awk -F ';' '$1 ~ /^info/ && match($1,/[0-9].*$/) {sum+=substr($1,RSTART,RLENGTH)} END {print sum}')
if [ -n "$response" ]; then
  echo "$response"
else
  echo "$result"
fi
