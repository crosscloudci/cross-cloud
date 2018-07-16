#!/usr/bin/env bash

ETCD_NAME=etcd-gcr-v3.3.8
SKYDNS_CONTAINER=skynetservices/skydns:2.5.3a
ETCD_CONTAINER=gcr.io/etcd-development/etcd:v3.3.8

# deploy etcd
rm -rf /tmp/etcd-data.tmp 
mkdir -p /tmp/etcd-data.tmp
docker rmi ${ETCD_CONTAINER} || true
nohup docker run \
-p 2379:2379 \
-p 2380:2380 \
--mount type=bind,source=/tmp/etcd-data.tmp,destination=/etcd-data \
--name ${ETCD_NAME} \
${ETCD_CONTAINER} \
/usr/local/bin/etcd \
--name s1 \
--data-dir /etcd-data \
--listen-client-urls http://0.0.0.0:2379 \
--advertise-client-urls http://${HOST_IP}:2379 \
--listen-peer-urls http://0.0.0.0:2380 \
--initial-advertise-peer-urls http://0.0.0.0:2380 \
--initial-cluster s1=http://0.0.0.0:2380 \
--initial-cluster-token tkn \
--initial-cluster-state new &>/dev/null &


rc=1
retry=0
while [[ $rc -ne 0 && retry -lt 20 ]];
do
   sleep 1
   docker exec ${ETCD_NAME} etcdctl --endpoints http://${HOST_IP}:2379 cluster-health
   rc=$?
   let retry++
done

# configure skydns
curl -X PUT -d value='{"dns_addr":"'${HOST_IP}':53", "ttl":60, "domain": "vsphere.local.", "nameservers": ["8.8.8.8:53","9.8.4.4:53"]}' http://${HOST_IP}:2379/v2/keys/skydns/config
if [ $? -ne 0 ];
then
   echo "configure skydns failed"
   exit -1
fi

# deploy skydns
docker run -d --net host --name test-skydns -e ETCD_MACHINES=http://${HOST_IP}:2379 ${SKYDNS_CONTAINER}
if [ $? -ne 0 ];
then
   echo "run skydns failed"
   exit -1
fi
