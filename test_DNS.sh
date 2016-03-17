#!/bin/bash
echo "First the DNS setup"
apt-get update
apt-get install bind9 dnsutils -y
echo "config /etc/hosts file"
tmpIP=`ifconfig |grep "192.168"|cut -c21-33`
echo $tmpIP
sed -i "2a ${tmpIP} mydomain.com myhostname" /etc/hosts
echo "config /etc/resolv.conf file"
sed -i "3a search mydomain.com\nnameserver ${tmpIP} " /etc/resolv.conf
echo "config /etc/bind/named.conf.options file "
sed -i '$a forwarders\{ \n202.96.134.33\n\};' /etc/bind/named.conf.options
echo "config /etc/bind/named.conf.local file "
sed -i '$a zone "mydomain.com"\{ \ntype master; \nfile "/var/cache/bind/mydomain.com.hosts"; \n\};\
\nzone "1.168.192.in-addr.arpa"\{ \ntype master; \nfile "/var/cache/bind/192.168.1.rev" \n\};' /etc/bind/named.conf.local
touch /var/cache/bind/mydomain.com.hosts
sed -i "i @ IN SOA mydomain.com. root.mydomain.com.( \n1317532240 \n10800 \n3600 \n604800 \n38400) \nmydomain.com. IN NS ns.mydomain.com. \nns.mydomain.com. IN A ${tmpIP} \nmydomain.com. IN A ${tmpIP}" /var/cache/bind/mydomain.com.hosts
touch /var/cache/bind/192.168.1.rev
tmpIP1=`ifconfig |grep "192.168"|cut -c31-33`
tmpIP2=${tmpIP1}.1.168.192.in-addr.arpa.
sed -i "i @ IN SOA mydomain.com. root.mydomain.com.( \n1317532345 \n10800 \n3600 \n604800 \n38400) \n 1.168.192.in-addr.arpa. IN NS mydomain.com.\n${tmpIP2} IN PTR ns.mydomain.com." /var/cache/bind/192.168.1.rev
ping mydomain.com -c 4





