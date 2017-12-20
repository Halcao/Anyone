#!/bin/sh
date
list="";
#for ip in $(arp | grep -v IP | awk '{print $1}'); 
#do 
#	list=$list"\n"$(grep $ip /tmp/dhcp.leases); 
#done; 
macList=$(iwinfo rai0 associlist | grep "^[[:alnum:]:]\{17\}" -o | tr '[A-Z]' '[a-z]' | tr '\n' ' ')
macList=$macList' '$(iwinfo ra0 associlist | grep "^[[:alnum:]:]\{17\}" -o | tr '[A-Z]' '[a-z]' | tr '\n' ' ')
for mac in $macList 
do
			list=$list"$"$(grep $mac /tmp/dhcp.leases)
	done
	curl -d "list=$list&date=$(date +%s)" halcao.me:8080/update

