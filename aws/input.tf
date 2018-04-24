variable "name" { default = "aws" }

variable "data_dir" { default = "/cncf/data/aws" }

# AWS Cloud Specific Settings
variable "aws_region" { default = "ap-southeast-2" }
variable "aws_key_name" { default = "cross-cloud" }
variable "aws_availability_zone" { default = "ap-southeast-2a" }
variable "vpc_cidr"        { default = "10.240.0.0/16" }
variable "subnet_cidr"     { default = "10.240.0.0/16"}

# DNS Configuration
variable "etcd_server" { default = "147.75.69.23:2379" }
variable "discovery_nameserver" { default = "147.75.69.23" } 

# VM Image and size
variable "admin_username" { default = "core" }
variable "aws_image_ami" { default = "ami-266d8b44"} # channel/stable type/hvm
variable "aws_master_vm_size" { default = "m3.medium" }
variable "aws_worker_vm_size" { default = "m4.4xlarge" }
variable "aws_bastion_vm_size" { default = "t2.nano" }

# Kubernetes
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_provider" { default = "aws" }
variable "cloud_config" { default = "" }
variable "cluster_domain" { default = "cluster.local" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10" }
variable "dns_service_ip" { default = "100.64.0.10" }
variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "1" }

# Deployment Artifact Versions
variable "etcd_artifact" { default = "https://storage.googleapis.com/etcd/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz" }
variable "cni_plugins_artifact" { default = "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz" }

variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kubelet" }
variable "kube_apiserver_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-apiserver" }
variable "kube_controller_manager_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-controller-manager" }
variable "kube_scheduler_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-scheduler"}
variable "kube_proxy_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.0/bin/linux/amd64/kube-proxy"}

variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.10.0"}
