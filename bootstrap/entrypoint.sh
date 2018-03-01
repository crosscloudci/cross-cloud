#!/bin/bash
source /etc/srv/kubernetes/bootstrap.env

sed -i "s/ETCD_BOOTSTRAP/$ETCD_BOOTSTRAP/g" ./bash.template
sed -i "s/NAME/$NAME/g" ./bash.template
sed -i "s/PRIVATE_IPV4/$PRIVATE_IPV4/g" ./bash.template
sed -i "s/PUBLIC_IPV4/$PUBLIC_IPV4/g" ./bash.template

source ./bash.template
