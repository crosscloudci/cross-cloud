#!/bin/bash
source /etc/srv/kubernetes/ip.env

sed -i "s/PRIVATE_IPV4/$PRIVATE_IPV4/g" ./bash.template
sed -i "s/PUBLIC_IPV4/$PUBLIC_IPV4/g" ./bash.template

source ./bash.template
