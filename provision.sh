#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_retry() {
    [ -z "${2}" ] && return 1
    echo -n ${1}
    until printf "." && "${@:2}" &>/dev/null; do sleep 5.2; done; echo "✓"
}

set -e
RED='\033[0;31m'
NC='\033[0m' # No Color

export TF_VAR_name="$2"
export TF_VAR_internal_tld=${TF_VAR_name}.cncf.demo
export TF_VAR_data_dir=$(pwd)/data/${TF_VAR_name}
export TF_VAR_aws_key_name=${TF_VAR_name}
export TF_VAR_packet_api_key=${PACKET_AUTH_TOKEN}
if [ ! -e $KUBERNETES_IMAGE ] ; then
  export TF_VAR_kubelet_image_url=$KUBERNETES_IMAGE
fi
if [ ! -e $KUBERNETES_TAG ] ; then
  export TF_VAR_kubelet_image_tag=$KUBERNETES_TAG
fi
# tfstate, sslcerts, and ssh keys are currently stored in TF_VAR_data_dir
mkdir -p $TF_VAR_data_dir

# Run CMD
if [ "$1" = "aws-deploy" ] ; then
    cd ${DIR}/aws
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=aws-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true
    time terraform apply ${DIR}/aws
    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/aws
        time terraform apply ${DIR}/aws
    fi

    ELB=$(terraform output external_elb)
    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Waiting for DNS to resolve for ${ELB}" ping -c1 "${ELB}"
    _retry "❤ Curling apiserver external elb" curl --insecure --silent "https://${ELB}"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
    kubectl cluster-info
elif [ "$1" = "aws-destroy" ] ; then
      cd ${DIR}/aws
      if [ "$3" = "s3" ]; then
          cp ../s3-backend.tf .
          terraform init \
                    -backend-config 'bucket=aws65972563' \
                    -backend-config "key=aws-${TF_VAR_name}" \
                    -backend-config 'region=ap-southeast-2'
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
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true
    terraform apply -target null_resource.ssl_ssh_cloud_gen ${DIR}/azure && \
        terraform apply -target module.dns.null_resource.dns_gen ${DIR}/azure && \
        time terraform apply ${DIR}/azure
    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true
        terraform apply -target null_resource.ssl_ssh_cloud_gen ${DIR}/azure && \
            terraform apply -target module.dns.null_resource.dns_gen ${DIR}/azure && \
            time terraform apply ${DIR}/azure
       fi 

elif [ "$1" = "azure-destroy" ] ; then
    cd ${DIR}/azure
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    terraform destroy -force -target null_resource.ssl_ssh_cloud_gen ${DIR}/azure && \
    terraform destroy -force -target module.dns.null_resource.dns_gen ${DIR}/azure && \
    terraform apply -target null_resource.ssl_ssh_cloud_gen ${DIR}/azure && \
    terraform apply -target module.dns.null_resource.dns_gen ${DIR}/azure && \
    time terraform destroy -force ${DIR}/azure || true
    
    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        terraform destroy -force -target null_resource.ssl_ssh_cloud_gen ${DIR}/azure && \
        terraform destroy -force -target module.dns.null_resource.dns_gen ${DIR}/azure && \
        terraform apply -target null_resource.ssl_ssh_cloud_gen ${DIR}/azure && \
        terraform apply -target module.dns.null_resource.dns_gen ${DIR}/azure && \
    time terraform destroy -force ${DIR}/azure || true
            fi

elif [ "$1" = "packet-deploy" ] ; then
    cd ${DIR}/packet
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=packet-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/packet
    time terraform apply ${DIR}/packet

    elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate" 
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/packet
        time terraform apply ${DIR}/packet
fi

    ELB=$(terraform output endpoint)
    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Waiting for DNS to resolve for ${ELB}" ping -c1 "${ELB}"
    _retry "❤ Curling apiserver external elb" curl --insecure --silent "https://${ELB}"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
    kubectl cluster-info
elif [ "$1" = "packet-destroy" ] ; then
     cd ${DIR}/packet
     if [ "$3" = "s3" ]; then
         cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=packet-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
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
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=gce-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/gce
    time terraform apply -target module.vpc.google_compute_subnetwork.cncf ${DIR}/gce
    time terraform apply ${DIR}/gce
    
elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        # ensure kubeconfig is written to disk on infrastructure refresh
        terraform taint -module=kubeconfig null_resource.kubeconfig || true ${DIR}/gce
        time terraform apply -target module.vpc.google_compute_subnetwork.cncf ${DIR}/gce
        time terraform apply ${DIR}/gce
    fi

    ELB=$(terraform output external_lb)
    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Waiting for DNS to resolve for ${ELB}" ping -c1 "${ELB}"
    _retry "❤ Curling apiserver external elb" curl --insecure --silent "https://${ELB}"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
    kubectl cluster-info

elif [ "$1" = "gce-destroy" ] ; then
    cd ${DIR}/gce
    if [ "$3" = "s3" ]; then
        cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=gce-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    time terraform destroy -force ${DIR}/gce || true # Allow to Fail and clean up network on next step
    time terraform destroy -force -target module.vpc.google_compute_subnetwork.cncf ${DIR}/gce
elif [ "$3" = "file" ]; then
        cp ../file-backend.tf .
        terraform init \
                  -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
        time terraform destroy -force ${DIR}/gce || true # Allow to Fail and clean up network on next step
        time terraform destroy -force -target module.vpc.google_compute_subnetwork.cncf ${DIR}/gce
fi

elif [ "$1" = "gke-deploy" ] ; then
cd ${DIR}/gke
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=gke-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true          
    time terraform apply -target module.vpc ${DIR}/gke && \
    time terraform apply ${DIR}/gke
elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint -module=kubeconfig null_resource.kubeconfig || true          
    time terraform apply -target module.vpc ${DIR}/gke && \
    time terraform apply ${DIR}/gke
fi

    ELB=$(terraform output endpoint)
    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Waiting for DNS to resolve for ${ELB}" ping -c1 "${ELB}"
    _retry "❤ Curling apiserver external elb" curl --insecure --silent "https://${ELB}"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
    kubectl cluster-info
elif [ "$1" = "gke-destroy" ] ; then
cd ${DIR}/gke
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=gke-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'

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


elif [ "$1" = "bluemix-deploy" ] ; then
cd ${DIR}/bluemix
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=bluemix-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint null_resource.kubeconfig || true
    time terraform apply ${DIR}/bluemix
elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate"
    # ensure kubeconfig is written to disk on infrastructure refresh
    terraform taint null_resource.kubeconfig || true
    time terraform apply ${DIR}/bluemix
fi

    export KUBECONFIG=${TF_VAR_data_dir}/kubeconfig
    echo "❤ Polling for cluster life - this could take a minute or more"
    _retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
    kubectl cluster-info
elif [ "$1" = "bluemix-destroy" ] ; then
cd ${DIR}/gke
if [ "$3" = "s3" ]; then
    cp ../s3-backend.tf .
    terraform init \
              -backend-config 'bucket=aws65972563' \
              -backend-config "key=bluemix-${TF_VAR_name}" \
              -backend-config 'region=ap-southeast-2'

    time terraform destroy -force ${DIR}/bluemix 

elif [ "$3" = "file" ]; then
    cp ../file-backend.tf .
    terraform init \
              -backend-config "path=/cncf/data/${TF_VAR_name}/terraform.tfstate" 
time terraform destroy -force ${DIR}/bluemix
fi
fi

