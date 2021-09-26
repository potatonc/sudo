#!/bin/bash

source /etc/os-release
if [[ ${ID} == 'ubuntu' ]]; then
	if [[ ${VERSION_ID} == '20.04' ]]; then
		apt-get update -y
		apt-get install libpcre3 libpcre3-dev gcc make -y
		apt-get install -y --no-install-recommends software-properties-common
    (echo -en "\n") | add-apt-repository ppa:vbernat/haproxy-2.1 --yes
    apt-get update -y
    apt-get install -y haproxy
    cd /etc/haproxy
    rm -f haproxy.cfg
		cd /opt/
		wget https://www.haproxy.org/download/1.8/src/haproxy-1.8.30.tar.gz
		tar xzvf haproxy-1.8.30.tar.gz
		cd haproxy-1.8.30
		make TARGET=linux-glibc
		make install
		mkdir -p /etc/haproxy
		mkdir -p /var/lib/haproxy
		touch /var/lib/haproxy/stats
		ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
		cp examples/haproxy.init /etc/init.d/haproxy
		chmod +x /etc/init.d/haproxy
		systemctl daemon-reload
		wget -O /etc/haproxy/haproxy.cfg "https://raw.githubusercontent.com/potatonc/webmin/master/haproxy.cfg"
		systemctl daemon-reload
		systemctl enable haproxy
		systemctl start haproxy
		systemctl restart haproxy
		sed -i 's/mode http/mode tcp/g' /etc/haproxy/haproxy.cfg
		systemctl restart haproxy
	fi
fi