#!/bin/sh
list="";
for ip in $(arp | grep -v IP | awk '{print $1}'); 
do 
	list=$list"\n"$(grep $ip /tmp/dhcp.leases); 
done; 
curl -d "list=$list" https://halcao.me:8080/update
