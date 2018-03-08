variable "name" { default = "gce" }
variable "master_node_count" { default = "3" }
variable "worker_node_count" { default = "1" }

variable "bastion_vm_size"   { default = "n1-standard-1" }
variable "master_vm_size"    { default = "n1-standard-1" }
variable "worker_vm_size"    { default = "n1-standard-16" }
variable "image_id"          { default = "coreos-stable-1298-7-0-v20170401"}
variable "disk_size"         { default = "50" }

variable "region"          { default = "us-central1" }
variable "zone"            { default = "us-central1-a" }

variable "cidr" { default = "10.240.0.0/16" }
variable "internal_lb_ip" { default = "10.240.0.100"}

variable "allow_ssh_cidr" { default = "0.0.0.0/0" }

variable "data_dir" { default = "/cncf/data/gce" }


# Kubernetes
variable "etcd_endpoint" {default = "127.0.0.1"}
variable "cloud_provider" { default = "gce" }
variable "cloud_config" { default = "" }
variable "cluster_domain" { default = "cluster.local" }
variable "cluster_name" { default = "kubernetes" }
variable "pod_cidr" { default = "100.96.0.0/11" }
variable "service_cidr"   { default = "100.64.0.0/13" }
variable "non_masquerade_cidr" { default = "100.64.0.0/10"}
variable "dns_service_ip" { default = "100.64.0.10" }

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

