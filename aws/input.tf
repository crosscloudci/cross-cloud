variable "name" { default = "aws" }

variable "data_dir" { default = "/cncf/data/aws" }

# AWS Cloud Specific Settings
variable "aws_region" { default = "ap-southeast-2" }
variable "aws_key_name" { default = "aws" }
variable "aws_availability_zone" { default = "ap-southeast-2a" }
variable "vpc_cidr"        { default = "10.0.0.0/16" }
variable "subnet_cidr_private"     { default = "10.0.240.0/24"}
variable "subnet_cidr_public"     { default = "10.0.241.0/24"}
variable "allow_ssh_cidr" { default = "0.0.0.0/0" }

# VM Image and size
variable "admin_username" { default = "core" }
variable "aws_image_ami" { default = "ami-266d8b44"} # channel/stable type/hvm
variable "aws_master_vm_size" { default = "m3.medium" }
variable "aws_worker_vm_size" { default = "m3.medium" }
variable "aws_bastion_vm_size" { default = "t2.nano" }

# Kubernetes
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_provider" { default = "aws" }
variable "cloud_config" { default = "" }
variable "cluster_domain" { default = "cluster.local" }
variable "cluster_name" { default = "kubernetes" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10"}
variable "dns_service_ip" { default = "100.64.0.10" }
variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "3" }
variable "worker_node_min" { default = "3" }
variable "worker_node_max" { default = "5" }

# Deployment Artifact Versions
variable "kubelet_artifact" { default = "https://storage.googleapis.com/kubernetes-release/release/v1.8.1/bin/linux/amd64/kubelet" }
variable "cni_artifact" { default = "https://github.com/containernetworking/cni/releases/download/v0.5.2/cni-amd64-v0.5.2.tgz" }

variable "etcd_image" { default = "gcr.io/google_containers/etcd"}
variable "etcd_tag" { default = "2.2.1"}
variable "kube_apiserver_image" { default = "gcr.io/google_containers/kube-apiserver"}
variable "kube_apiserver_tag" { default = "v1.8.1"}
variable "kube_controller_manager_image" { default = "gcr.io/google_containers/kube-controller-manager"}
variable "kube_controller_manager_tag" { default = "v1.8.1"}
variable "kube_scheduler_image" { default = "gcr.io/google_containers/kube-scheduler"}
variable "kube_scheduler_tag" { default = "v1.8.1"}
variable "kube_proxy_image" { default = "gcr.io/google_containers/kube-proxy"}
variable "kube_proxy_tag" { default = "v1.8.1"}
