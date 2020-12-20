#!/bin/bash

###
# DNS ZONEWALK USING NSEC RECORDS
###


usage() {
	echo '[!] Usage:' $0 'domain [@nameserver]'
	exit 1
}


# check cmdline arguments. Print usage if not correct
if [ $# == 1 ]
then
        ns=1.1.1.1
        domain=$1

elif [ $# == 2 ]
then
	if [ ${2:0:1} == '@' ]
	then
        	domain=$1
		ns=${2:1}
	elif [ ${1:0:1} == '@' ]
	then
        	domain=$2
		ns=${1:1}
	else
		usage
	fi
else
	usage
fi

filename=$domain.zones.txt
subdomain=$domain

echo [*] Walking: $domain
echo [*] Using nameserver: $ns
echo

while :;do
	echo Adding: $subdomain |tee -a $filename # add subdomain to file
       	subdomain=$(dig +short "${subdomain}" NSEC @$ns| cut -d' ' -f1) # get next subdomian from nsec record
	subdomain=${subdomain%.} # remove trailing .

	# check if nextsubdomain equals domain, if it is we've reached the end
	if [ $subdomain = $domain ];then
		exit
	fi
	sleep 1 # ratelimit. one request per second
done
exit 0





