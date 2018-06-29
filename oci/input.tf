variable "name" { default = "oci" }
variable "cloud_provider" { default = "oracle"}
variable "data_dir" { default = "/cncf/data/oci" }

# oci auth settings
variable "oci_tenancy_ocid" { default=""}
variable "oci_user_ocid" { default="" }
variable "oci_fingerprint" { default="" }
variable "oci_private_key_path" { default="/cncf/keys/oci_api_key.pem" }
variable "oci_region" { default = "us-phoenix-1" }

# general
variable "label_prefix" { default = "crosscloud"}
variable "ubuntu_linux_image_name" { default = "Canonical-Ubuntu-16.04-2018.06.18-0" }
variable "coreos_image_ocid" { default = "ocid1.image.oc1.phx.aaaaaaaaurr4h7hwzx234jxr3tieymfdqqroddcr7rneel4rzhhlxyogddmq" }

# ssh
variable "ssh_private_key" { default = "" }
variable "ssh_public_key" { default = "" }

# Network vars
variable "network_cidrs" {
  type = "map"
  default = {
    LBAAS-PHOENIX-1-CIDR  = "129.144.0.0/12"
    LBAAS-ASHBURN-1-CIDR  = "129.213.0.0/16"
    VCN-CIDR              = "10.0.0.0/16"
    kubeSubnetAD1         = "10.0.15.0/24"
    kubeSubnetAD2         = "10.0.16.0/24"
    LbSubnetAD1           = "10.0.17.0/24"
    LbSubnetAD2           = "10.0.18.0/24"
    KubeSubnetSshIngress  = "0.0.0.0/0"
  }
}

# Master vars
variable "master_node_count" { default = "1" }
variable "master_image_id" { default = "Canonical-Ubuntu-16.04"}
variable "master_shape" { default = "VM.Standard2.16" }

# Worker vars
variable "worker_node_count" { default = "1" }
variable "worker_image_id" { default = "Canonical-Ubuntu-16.04"}
variable "worker_shape" { default = "VM.Standard2.16" }

# DNS Configuration
variable "etcd_server" { default = "147.75.69.23:2379" }
variable "discovery_nameserver" { default = "147.75.69.23" }

# Load balancer configuration
variable "master_lb_shape" { default="100Mbps"}

# Kubernetes configuration
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_config" { default = "--cloud-config=/etc/srv/kubernetes/cloud-config" }
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10" }
variable "dns_service_ip" { default = "100.64.0.10" }

# Kubernetes artifacts
variable "etcd_artifact" { default = "https://storage.googleapis.com/etcd/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz" }
variable "cni_plugins_artifact" { default = "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz" }
variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kubelet" }
variable "kube_apiserver_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-apiserver" }
variable "kube_controller_manager_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-controller-manager" }
variable "kube_scheduler_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-scheduler"}
variable "kube_proxy_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-proxy"}
variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.10.1"}