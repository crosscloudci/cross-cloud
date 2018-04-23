#!/bin/bash
# Usage
#
# provision.sh <provider>-<command> <name> <config-backend>
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_retry() {
    [ -z "${2}" ] && return 1
    echo -n ${1}
    until printf "." && "${@:2}" &>/dev/null; do sleep 5.2; done; echo "✓"
}

set -e
RED='\033[0;31m'
NC='\033[0m' # No Color

# Setup Enviroment Using $NAME
export TF_VAR_name="$2"
export TF_VAR_data_dir=$(pwd)/data/"$4"
export TF_VAR_packet_api_key=${PACKET_AUTH_TOKEN}

# Configure Artifacts
if [ ! -e $KUBELET_ARTIFACT ] ; then
    export TF_VAR_kubelet_artifact=$KUBELET_ARTIFACT
fi

if [ ! -e $CNI_ARTIFACT ] ; then
    export TF_VAR_cni_artifact=$CNI_ARTIFACT
fi


if [ ! -e $ETCD_ARTIFACT ] ; then
  export TF_VAR_etcd_artifact=$ETCD_ARTIFACT
fi

if [ ! -e $KUBE_APISERVER_ARTIFACT ] ; then
    export TF_VAR_kube_apiserver_artifact=$KUBE_APISERVER_ARTIFACT
fi

if [ ! -e $KUBE_CONTROLLER_MANAGER_ARTIFACT ] ; then
    export TF_VAR_kube_controller_manager_artifact=$KUBE_CONTROLLER_MANAGER_ARTIFACT
fi

if [ ! -e $KUBE_SCHEDULER_ARTIFACT ] ; then
    export TF_VAR_kube_scheduler_artifact=$KUBE_SCHEDULER_ARTIFACT
fi

if [ ! -e $KUBE_PROXY_IMAGE ] ; then
    export TF_VAR_kube_proxy_image=$KUBE_PROXY_IMAGE
fi

if [ ! -e $KUBE_PROXY_TAG ] ; then
    export TF_VAR_kube_proxy_tag=$KUBE_PROXY_TAG
fi


 
# tfstate, sslcerts, and ssh keys are currently stored in TF_VAR_data_dir
mkdir -p $TF_VAR_data_dir

# Run CMD
if [ "$1" = "aws-deploy" ] ; then
    cd ${DIR}/aws
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=aws-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true
    time terraform apply -auto-approve ${DIR}/aws
    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/aws
        time terraform apply -auto-approve  ${DIR}/aws
    fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    _retry "❤ Trying to connect to cluster with kubectl" kubectl get cs
    _retry "❤ Ensure that the kube-system namespaces exists" kubectl get namespace kube-system
    # export NODES="$(expr $TF_VAR_master_node_count + $TF_VAR_worker_node_count)"
    # KUBECTL_PATH=$(which kubectl) NUM_NODES="$NODES" KUBERNETES_PROVIDER=local ${DIR}/validate-cluster/cluster/validate-cluster.sh || true
    # _retry "❤ Installing Helm" helm init
    # _retry "Wait for Tiller Deployment to be available" kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system
elif [ "$1" = "aws-destroy" ] ; then
      cd ${DIR}/aws
      if [ "$3" = "s3" ]; then
          cp ../s3-backend.tf .
          terraform init \
                    -backend-config "bucket=${AWS_BUCKET}" \
                    -backend-config "key=aws-${TF_VAR_name}" \
                    -backend-config "region=${AWS_DEFAULT_REGION}"
    time terraform destroy -force ${DIR}/aws
      elif [ "$3" = "file" ]; then
          cp ../file-backend.tf .
          terraform init \
                    -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
          time terraform destroy -force ${DIR}/aws

       fi

elif [ "$1" = "azure-deploy" ] ; then
    # There are some dependency issues around cert,sshkey,k8s_cloud_config, and dns
    # since they use files on disk that are created on the fly
    # should probably move these to data resources
    cd ${DIR}/azure
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=azure-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true
        terraform apply -target azurerm_resource_group.cncf -auto-approve ${DIR}/azure && \
        terraform apply -target module.network.azurerm_virtual_network.cncf -auto-approve ${DIR}/azure || true && \
        terraform apply -target module.network.azurerm_subnet.cncf -auto-approve ${DIR}/azure || true && \
        time terraform apply -auto-approve ${DIR}/azure

    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true
            terraform apply -target azurerm_resource_group.cncf -auto-approve ${DIR}/azure && \
            terraform apply -target module.network.azurerm_virtual_network.cncf -auto-approve ${DIR}/azure || true && \
            terraform apply -target module.network.azurerm_subnet.cncf -auto-approve ${DIR}/azure || true && \
            time terraform apply -auto-approve ${DIR}/azure
       fi 

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    _retry "❤ Trying to connect to cluster with kubectl" kubectl get cs
    _retry "❤ Ensure that the kube-system namespaces exists" kubectl get namespace kube-system
    # export NODES="$(expr $TF_VAR_master_node_count + $TF_VAR_worker_node_count)"
    # KUBECTL_PATH=$(which kubectl) NUM_NODES="$NODES" KUBERNETES_PROVIDER=local ${DIR}/validate-cluster/cluster/validate-cluster.sh || true
    # _retry "❤ Installing Helm" helm init
    # _retry "Wait for Tiller Deployment to be available" kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system


elif [ "$1" = "azure-destroy" ] ; then
    cd ${DIR}/azure
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=azure-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    time terraform destroy -force ${DIR}/azure || true

    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
    time terraform destroy -force ${DIR}/azure || true
    fi

# Begin OpenStack
elif [[ "$1" = "openstack-deploy" || "$1" = "openstack-destroy" ]] ; then
    cd ${DIR}/openstack

    # initialize based on the config type
    if [ "$3" = "s3" ] ; then
        cp ../s3-backend.tf .
        terraform init \
            -backend-config "bucket=${AWS_BUCKET}" \
            -backend-config "key=openstack-${TF_VAR_name}" \
            -backend-config "region=${AWS_DEFAULT_REGION}"
    elif [ "$3" = "file" ] ; then
        cp ../file-backend.tf .
        terraform init -backend-config "path=/cncf/data/${TF_VAR_NAME}/terraform.tfstate"
    fi

    # deploy/destroy implementations
    if [ "$1" = "openstack-deploy" ] ; then
        terraform taint -module=kubeconfig null_resource.kubeconfig || true
        time terraform apply -auto-approve ${DIR}/openstack
    elif [ "$1" = "openstack-destroy" ] ; then
        time terraform destroy -force ${DIR}/openstack || true
        # Exit after destroying resources as further commands cause hang
        exit
    fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    _retry "❤ Trying to connect to cluster with kubectl" kubectl get cs
    _retry "❤ Ensure that the kube-system namespaces exists" kubectl get namespace kube-system
    # export NODES="$(expr $TF_VAR_master_node_count + $TF_VAR_worker_node_count)"
    # KUBECTL_PATH=$(which kubectl) NUM_NODES="$NODES" KUBERNETES_PROVIDER=local ${DIR}/validate-cluster/cluster/validate-cluster.sh || true
    # _retry "❤ Installing Helm" helm init
    # _retry "Wait for Tiller Deployment to be available" kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system
# End OpenStack

elif [ "$1" = "packet-deploy" ] ; then
    cd ${DIR}/packet
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=packet-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    # ensure kubeconfig & resolv.conf is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/packet
    time terraform apply -auto-approve ${DIR}/packet

    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate" 
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/packet
        time terraform apply -auto-approve ${DIR}/packet
fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    _retry "❤ Trying to connect to cluster with kubectl" kubectl get cs
    _retry "❤ Ensure that the kube-system namespaces exists" kubectl get namespace kube-system
    # export NODES="$(expr $TF_VAR_master_node_count + $TF_VAR_worker_node_count)"
    # KUBECTL_PATH=$(which kubectl) NUM_NODES="$NODES" KUBERNETES_PROVIDER=local ${DIR}/validate-cluster/cluster/validate-cluster.sh || true
    # _retry "❤ Installing Helm" helm init
    # _retry "Wait for Tiller Deployment to be available" kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system

elif [ "$1" = "packet-destroy" ] ; then
     cd ${DIR}/packet
     if [ "$3" = "s3" ]; then
         cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=packet-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    time terraform destroy -force ${DIR}/packet

elif [ "$3" = "file" ]; then
         cp ../file-backend.tf .
         terraform init \
                   -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
         time terraform destroy -force ${DIR}/packet
fi

elif [ "$1" = "gce-deploy" ] ; then
    cd ${DIR}/gce
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=gce-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/gce
    time terraform apply -target module.vpc.google_compute_subnetwork.cncf -auto-approve ${DIR}/gce
    time terraform apply -auto-approve ${DIR}/gce

elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/gce
        time terraform apply -target module.vpc.google_compute_subnetwork.cncf -auto-approve ${DIR}/gce
        time terraform apply -auto-approve ${DIR}/gce
    fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    _retry "❤ Trying to connect to cluster with kubectl" kubectl get cs
    _retry "❤ Ensure that the kube-system namespaces exists" kubectl get namespace kube-system
    # export NODES="$TF_VAR_worker_node_count"
    # KUBECTL_PATH=$(which kubectl) NUM_NODES="$NODES" KUBERNETES_PROVIDER=local ${DIR}/validate-cluster/cluster/validate-cluster.sh || true
    # _retry "❤ Installing Helm" helm init
    # _retry "Wait for Tiller Deployment to be available" kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system


elif [ "$1" = "gce-destroy" ] ; then
    cd ${DIR}/gce
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=gce-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    time terraform destroy -force ${DIR}/gce || true # Allow to Fail and clean up network on next step
    time terraform destroy -force -target module.vpc.google_compute_subnetwork.cncf ${DIR}/gce
    time terraform destroy -force -target module.vpc.google_compute_network.cncf ${DIR}/gce
elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        time terraform destroy -force ${DIR}/gce || true # Allow to Fail and clean up network on next step
        time terraform destroy -force -target module.vpc.google_compute_subnetwork.cncf ${DIR}/gce
        time terraform destroy -force -target module.vpc.google_compute_network.cncf ${DIR}/gce
fi

elif [ "$1" = "gke-deploy" ] ; then
cd ${DIR}/gke
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=gke-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    time terraform apply -target module.vpc -auto-approve ${DIR}/gke && \
    time terraform apply -auto-approve ${DIR}/gke
elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
    time terraform apply -target module.vpc -auto-approve ${DIR}/gke && \
    time terraform apply -auto-approve ${DIR}/gke
fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo $GOOGLE_CREDENTIALS > ${TF_VAR_data_dir}/keyfile.json
    gcloud auth activate-service-account $GOOGLE_AUTH_EMAIL --key-file ${TF_VAR_data_dir}/keyfile.json --project $GOOGLE_PROJECT
    gcloud container clusters get-credentials $TF_VAR_name --zone $GOOGLE_ZONE --project $GOOGLE_PROJECT

    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info 
    kubectl cluster-info

elif [ "$1" = "gke-destroy" ] ; then
cd ${DIR}/gke
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=gke-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"

    time terraform destroy -force -target module.cluster.google_container_cluster.cncf ${DIR}/gke || true 
    echo "sleep" && sleep 10 && \
    time terraform destroy -force -target module.vpc.google_compute_network.cncf ${DIR}/gke || true 
    time terraform destroy -force ${DIR}/gke || true

elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate" 
time terraform destroy -force -target module.cluster.google_container_cluster.cncf ${DIR}/gke || true 
echo "sleep" && sleep 10 && \
time terraform destroy -force -target module.vpc.google_compute_network.cncf ${DIR}/gke || true 
time terraform destroy -force ${DIR}/gke || true
fi


elif [ "$1" = "ibmcloud-deploy" ] ; then
cd ${DIR}/ibm
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=ibm-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint null_resource.kubeconfig || true
    time terraform apply -auto-approve ${DIR}/ibm
elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint null_resource.kubeconfig || true
    time terraform apply -auto-approve ${DIR}/ibm
fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
    kubectl cluster-info
    _retry "❤ Installing Helm" helm init
    kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system

elif [ "$1" = "ibmcloud-destroy" ] ; then
cd ${DIR}/ibm
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config "bucket=${AWS_BUCKET}" \
              -backend-config "key=ibm-${TF_VAR_name}" \
              -backend-config "region=${AWS_DEFAULT_REGION}"
    time terraform destroy -force ${DIR}/ibm

elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate" 
time terraform destroy -force ${DIR}/ibm
fi
fi
 
