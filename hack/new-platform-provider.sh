#!/bin/sh

# posix compliant
# verified by https://www.shellcheck.net

set -e
! "${SHELL:-/bin/sh}" -c 'set -o pipefail' >/dev/null 2>&1 || set -o pipefail

usage() {
  cat <<EOF 1>&2
usage: ${0} PLATFORM
  Creates a new Cross-cloud provider for the specified PLATFORM.
EOF
}

[ "${#}" -ge "1" ] || { echo "PLATFORM is required" 1>&2; usage; exit 1; }

# Store the name of the platform.
platform="${1}"

# Translate the name of the platform to all lower case.
lplatform="$(echo "${platform}" | tr '[:upper:]' '[:lower:]')"

printf '* creating skeleton for %s...' "${platform}"

# Create the directories for the platform provider.
mkdir -p "${lplatform}"
mkdir -p "${lplatform}/modules/load_balancer"
mkdir -p "${lplatform}/modules/master"
mkdir -p "${lplatform}/modules/worker"

# Create the README file.
cat <<EOF >"${lplatform}/README.md"
# ${platform} Provider
This directory contains the assets that enable Cross-cloud integration with the
${platform} provider.

## Prerequisites
This section highlights the requirements necessary to integrate Cross-cloud
testing with ${platform}:

**Required**
* [Docker](#docker)

### Docker
Docker is required to provision the test environment. The environment is 
provisioned using the container image defined in this project's top-level 
directory:

\`\`\`shell
$ docker build --tag provisioning ../
\`\`\`

## Getting Stared
Running the Cross-cloud tests with ${platform} is separated into three phases:

* [Configure](#configure)
* [Deploy](#deploy)
* [Destroy](#destroy)

### Configure
The following environment variables are used to configure Cross-cloud 
integration with ${platform}:

| Name | Description |
|------|-------------|
| \`KEYMASTER\` | Vinz Clortho |
| \`GATEKEEPER\` | Zuul |

### Deploy
The following command can be used to provision a Cross-cloud environment to 
${platform}:

\`\`\`shell
\$ docker run --rm -it --dns 147.75.69.23 --dns 8.8.8.8 \\
  -v \$(pwd)/data:/cncf/data \\
  -e BACKEND=file \\
  -e CLOUD=${lplatform} \\
  -e COMMAND=deploy \\
  -e NAME=kubecon \\
  provisioning
\`\`\`

The helper script \`deploy.sh\` in this directory may also be used:
\`\`\`shell
\$ hack/deploy.sh NAME
\`\`\`

### Destroy
The following command can be used to deprovision a Cross-cloud environment 
deployed to ${platform}:

\`\`\`shell
\$ docker run --rm -it --dns 147.75.69.23 --dns 8.8.8.8 \\
  -v \$(pwd)/data:/cncf/data \\
  -e BACKEND=file \\
  -e CLOUD=${lplatform} \\
  -e COMMAND=destroy \\
  -e NAME=kubecon \\
  provisioning
\`\`\`

The helper script \`destroy.sh\` in this directory may also be used:
\`\`\`shell
\$ hack/destroy.sh NAME
\`\`\`
EOF

# Create the hack directory.
mkdir -p "${lplatform}/hack"

# hack/empty.env
# hack/run.sh
# hack/deploy.sh
# hack/destroy.sh
touch "${lplatform}/hack/empty.env"

cat <<EOF >"${lplatform}/hack/run.sh"
#!/bin/sh

# posix compliant
# verified by https://www.shellcheck.net

# The script takes two arguments, the command and the name of the cluster.
[ "\${#}" -eq 2 ] || { echo "usage: \${0} COMMAND NAME" 1>&2; exit 1; }

# If ENV_FILE is the path to a file, use it as the environment variable
# file, otherwise use the project's empty file, empty.env.
[ -f "\${ENV_FILE}" ] || ENV_FILE="\$(dirname "\${0}")/empty.env"

exec docker run --rm -it --dns 147.75.69.23 --dns 8.8.8.8 \\
  -v "\$(pwd)/data:/cncf/data" \\
  -e BACKEND=file \\
  -e CLOUD=${lplatform} \\
  -e COMMAND="\${1}" \\
  -e NAME="\${2}" \\
  --env-file="\${ENV_FILE}" \\
  provisioning
EOF

cat <<EOF >"${lplatform}/hack/deploy.sh"
#!/bin/sh

# posix compliant
# verified by https://www.shellcheck.net

# The script takes one arguments, the name of the cluster.
[ -n "\${1}" ] || { echo "usage: \${0} NAME" 1>&2; exit 1; }

exec "\$(dirname "\${0}")/run.sh" deploy "\${1}"
EOF

cat <<EOF >"${lplatform}/hack/destroy.sh"
#!/bin/sh

# posix compliant
# verified by https://www.shellcheck.net

# The script takes one arguments, the name of the cluster.
[ -n "\${1}" ] || { echo "usage: \${0} NAME" 1>&2; exit 1; }

exec "\$(dirname "\${0}")/run.sh" destroy "\${1}"
EOF

# .gitignore
cat <<EOF >"${lplatform}/.gitignore"
/data
EOF

# providers.tf
cat <<EOF >"${lplatform}/providers.tf"
# Configure the platform provider
provider "${lplatform}" {
  # Do the platform-specific configuration here
}

# Configure the gzip provider
provider "gzip" {
  compressionlevel = "BestCompression"
}
EOF

# cloud.conf
# cloud.tf
cat <<EOF >"${lplatform}/cloud.conf"
[Global]
host="\${host}"
user="\${user}"
pass="\${pass}"
EOF

cat <<EOF >"${lplatform}/cloud.tf"
data "template_file" "cloud_conf" {
  template = "\${file("\${path.module}/cloud.conf")}"

  vars {
    host = "\${var.cloud_host}"
    user = "\${var.cloud_user}"
    pass = "\${var.cloud_pass}"
  }
}
EOF

# input.tf
cat <<EOF >"${lplatform}/input.tf"
# The name of the cluster
variable "name" {
  default = "${lplatform}"
}

# The directory inside the container where the Terraform data is stored
variable "data_dir" {
  default = "/cncf/data/${lplatform}"
}

# DNS Configuration
variable "etcd_server" {
  default = "147.75.69.23:2379"
}

variable "discovery_nameserver" {
  default = "147.75.69.23"
}

# Control plane node configuration
variable "master_node_count" {
  default = "3"
}

variable "master_cpus" {
  default = "8"
}

variable "master_memory" {
  default = "32768"
}

# Worker node configuration
variable "worker_node_count" {
  default = "1"
}

variable "worker_cpus" {
  default = "16"
}

variable "worker_memory" {
  default = "65536"
}

# Kubernetes configuration
variable "etcd_endpoint" {
  default = "127.0.0.1"
}

variable "cloud_provider" {
  default = "${lplatform}"
}

variable "cloud_config" {
  default = "--cloud-config=/etc/srv/kubernetes/cloud-config"
}

variable "cluster_domain" {
  default = "cluster.local"
}

variable "pod_cidr" {
  default = "100.96.0.0/11"
}

variable "service_cidr" {
  default = "100.64.0.0/13"
}

variable "non_masquerade_cidr" {
  default = "100.64.0.0/10"
}

variable "dns_service_ip" {
  default = "100.64.0.10"
}

# Deployment Artifact Versions
variable "etcd_artifact" {
  default = "https://storage.googleapis.com/etcd/v3.2.8/etcd-v3.2.8-linux-amd64.tar.gz"
}

variable "cni_artifact" {
  default = "https://github.com/containernetworking/cni/releases/download/v0.6.0/cni-amd64-v0.6.0.tgz"
}

variable "cni_plugins_artifact" {
  default = "https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz"
}

variable "kubelet_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kubelet"
}

variable "kube_apiserver_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-apiserver"
}

variable "kube_controller_manager_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-controller-manager"
}

variable "kube_scheduler_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-scheduler"
}

variable "kube_proxy_artifact" {
  default = "https://storage.googleapis.com/kubernetes-release/release/v1.10.1/bin/linux/amd64/kube-proxy"
}

variable "kube_proxy_image" {
  default = "gcr.io/google_containers/kube-proxy"
}

variable "kube_proxy_tag" {
  default = "v1.10.1"
}
EOF

# modules.tf
cat <<EOF >"${lplatform}/modules.tf"
module "master" {
  source = "./modules/master"

  name            = "\${var.name}"
  count           = "\${var.master_node_count}"
  hostname_suffix = "\${var.name}.\${var.cloud_provider}.local"
  hostname_path   = "/etc/hostname"
  cloud_init      = "\${module.master_templates.master_cloud_init}"
  cpus            = "\${var.master_cpus}"
  memory          = "\${var.master_memory}"
}

module "master_templates" {
  source = "../master_templates-v1.10.0"

  hostname        = "\${var.name}-master"
  hostname_suffix = "\${var.name}.\${var.cloud_provider}.local"
  hostname_path   = "/etc/hostname"

  master_node_count = "\${var.master_node_count}"
  name              = "\${var.name}"
  etcd_endpoint     = "etcd.\${var.name}.\${var.cloud_provider}.local"
  etcd_discovery    = "\${var.name}.\${var.cloud_provider}.local"

  etcd_artifact                    = "\${var.etcd_artifact}"
  kube_apiserver_artifact          = "\${var.kube_apiserver_artifact}"
  kube_controller_manager_artifact = "\${var.kube_controller_manager_artifact}"
  kube_scheduler_artifact          = "\${var.kube_scheduler_artifact}"

  cloud_provider          = "\${var.cloud_provider}"
  cloud_config            = "\${var.cloud_config}"
  cluster_domain          = "\${var.cluster_domain}"
  pod_cidr                = "\${var.pod_cidr}"
  service_cidr            = "\${var.service_cidr}"
  dns_service_ip          = "\${var.dns_service_ip}"

  ca                = "\${module.tls.ca}"
  ca_key            = "\${module.tls.ca_key}"
  apiserver         = "\${module.tls.apiserver}"
  apiserver_key     = "\${module.tls.apiserver_key}"
  controller        = "\${module.tls.controller}"
  controller_key    = "\${module.tls.controller_key}"
  scheduler         = "\${module.tls.scheduler}"
  scheduler_key     = "\${module.tls.scheduler_key}"
  cloud_config_file = ""

  dns_conf = "\${module.dns.dns_conf}"
  dns_dhcp = ""
}

module "worker" {
  source = "./modules/worker"

  name            = "\${var.name}"
  count           = "\${var.worker_node_count}"
  hostname_suffix = "\${var.name}.\${var.cloud_provider}.local"
  hostname_path   = "/etc/hostname"
  cloud_init      = "\${module.worker_templates.worker_cloud_init}"
  cpus            = "\${var.worker_cpus}"
  memory          = "\${var.worker_memory}"
}

module "worker_templates" {
  source = "../worker_templates-v1.10.0"

  hostname        = "\${var.name}-worker"
  hostname_suffix = "\${var.name}.\${var.cloud_provider}.local"
  hostname_path   = "/etc/hostname"

  worker_node_count = "\${var.worker_node_count}"

  kubelet_artifact     = "\${var.kubelet_artifact}"
  cni_artifact         = "\${var.cni_artifact}"
  cni_plugins_artifact = "\${var.cni_plugins_artifact}"
  kube_proxy_image     = "\${var.kube_proxy_image}"
  kube_proxy_tag       = "\${var.kube_proxy_tag}"

  cloud_provider          = "\${var.cloud_provider}"
  cloud_config            = "\${var.cloud_config}"
  cluster_domain          = "\${var.cluster_domain}"
  pod_cidr                = "\${var.pod_cidr}"
  non_masquerade_cidr     = "\${var.non_masquerade_cidr}"
  dns_service_ip          = "\${var.dns_service_ip}"
  internal_lb_ip          = "internal-master.\${var.name}.\${var.cloud_provider}.local"

  ca                = "\${module.tls.ca}"
  kubelet           = "\${module.tls.kubelet}"
  kubelet_key       = "\${module.tls.kubelet_key}"
  proxy             = "\${module.tls.proxy}"
  proxy_key         = "\${module.tls.proxy_key}"
  bootstrap         = "\${module.master_templates.bootstrap}"
  cloud_config_file = ""

  dns_conf = "\${module.dns.dns_conf}"
  dns_dhcp = ""
}

module "load_balancer" {
  source = "./modules/load_balancer"

  target_ips = ["\${split(",", module.master.master_ips)}"]
}

module "dns" {
  source = "../dns-etcd"

  name                 = "\${var.name}"
  etcd_server          = "\${var.etcd_server}"
  discovery_nameserver = "\${var.discovery_nameserver}"
  upstream_dns         = "DNS=8.8.8.8"
  cloud_provider       = "\${var.cloud_provider}"

  master_ips        = "\${module.master.master_ips}"
  public_master_ips = "\${module.load_balancer.public_address}"
  worker_ips        = "\${module.worker.worker_ips}"

  master_node_count = "\${var.master_node_count}"
  worker_node_count = "\${var.worker_node_count}"
}

module "tls" {
  source = "../tls"

  tls_ca_cert_subject_common_name       = "kubernetes"
  tls_ca_cert_subject_locality          = "San Francisco"
  tls_ca_cert_subject_organization      = "Kubernetes"
  tls_ca_cert_subject_organization_unit = "Kubernetes"
  tls_ca_cert_subject_province          = "California"
  tls_ca_cert_subject_country           = "US"
  tls_ca_cert_validity_period_hours     = 1000
  tls_ca_cert_early_renewal_hours       = 100

  tls_admin_cert_subject_common_name       = "admin"
  tls_admin_cert_subject_locality          = "San Francisco"
  tls_admin_cert_subject_organization      = "system:masters"
  tls_admin_cert_subject_organization_unit = "Kubernetes"
  tls_admin_cert_subject_province          = "Callifornia"
  tls_admin_cert_subject_country           = "US"
  tls_admin_cert_validity_period_hours     = 1000
  tls_admin_cert_early_renewal_hours       = 100
  tls_admin_cert_ip_addresses              = "127.0.0.1"
  tls_admin_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_apiserver_cert_subject_common_name       = "kubernetes"
  tls_apiserver_cert_subject_locality          = "San Francisco"
  tls_apiserver_cert_subject_organization      = "Kubernetes"
  tls_apiserver_cert_subject_organization_unit = "Kubernetes"
  tls_apiserver_cert_subject_province          = "California"
  tls_apiserver_cert_subject_country           = "US"
  tls_apiserver_cert_validity_period_hours     = "1000"
  tls_apiserver_cert_early_renewal_hours       = "100"
  tls_apiserver_cert_ip_addresses              = "127.0.0.1,100.64.0.1,\${var.dns_service_ip}"
  tls_apiserver_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.\${var.name}.\${var.cloud_provider}.local"

  tls_controller_cert_subject_common_name       = "system:kube-controller-manager"
  tls_controller_cert_subject_locality          = "San Francisco"
  tls_controller_cert_subject_organization      = "system:kube-controller-manager"
  tls_controller_cert_subject_organization_unit = "Kubernetes"
  tls_controller_cert_subject_province          = "California"
  tls_controller_cert_subject_country           = "US"
  tls_controller_cert_validity_period_hours     = "1000"
  tls_controller_cert_early_renewal_hours       = "100"
  tls_controller_cert_ip_addresses              = "127.0.0.1"
  tls_controller_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_scheduler_cert_subject_common_name       = "system:kube-scheduler"
  tls_scheduler_cert_subject_locality          = "San Francisco"
  tls_scheduler_cert_subject_organization      = "system:kube-scheduler"
  tls_scheduler_cert_subject_organization_unit = "Kubernetes"
  tls_scheduler_cert_subject_province          = "California"
  tls_scheduler_cert_subject_country           = "US"
  tls_scheduler_cert_validity_period_hours     = "1000"
  tls_scheduler_cert_early_renewal_hours       = "100"
  tls_scheduler_cert_ip_addresses              = "127.0.0.1"
  tls_scheduler_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"

  tls_kubelet_cert_subject_common_name       = "kubernetes"
  tls_kubelet_cert_subject_locality          = "San Francisco"
  tls_kubelet_cert_subject_organization      = "Kubernetes"
  tls_kubelet_cert_subject_organization_unit = "Kubernetes"
  tls_kubelet_cert_subject_province          = "California"
  tls_kubelet_cert_subject_country           = "US"
  tls_kubelet_cert_validity_period_hours     = "1000"
  tls_kubelet_cert_early_renewal_hours       = "100"
  tls_kubelet_cert_ip_addresses              = "127.0.0.1"
  tls_kubelet_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.\${var.name}.\${var.cloud_provider}.local"

  tls_proxy_cert_subject_common_name       = "system:kube-proxy"
  tls_proxy_cert_subject_locality          = "San Francisco"
  tls_proxy_cert_subject_organization      = "system:node-proxier"
  tls_proxy_cert_subject_organization_unit = "Kubernetes"
  tls_proxy_cert_subject_province          = "California"
  tls_proxy_cert_subject_country           = "US"
  tls_proxy_cert_validity_period_hours     = "1000"
  tls_proxy_cert_early_renewal_hours       = "100"
  tls_proxy_cert_ip_addresses              = "127.0.0.1"
  tls_proxy_cert_dns_names                 = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
}

module "kubeconfig" {
  source = "../kubeconfig"

  data_dir   = "\${var.data_dir}"
  endpoint   = "master.\${var.name}.\${var.cloud_provider}.local"
  name       = "\${var.name}"
  ca         = "\${module.tls.ca}"
  client     = "\${module.tls.admin}"
  client_key = "\${module.tls.admin_key}"
}
EOF

# modules/load_balancer/input.tf
# modules/load_balancer/output.tf
cat <<EOF >"${lplatform}/modules/load_balancer/input.tf"
variable "target_ips" {
  type = "list"
}
EOF

cat <<EOF >"${lplatform}/modules/load_balancer/output.tf"
# The "load-balancer" just returns the first IP address in the list of
# IP addresses provided to this module. If a true load-balancer is
# required, use this module to configure it, and emit the IP address
# of the load balancer using this output variable.
output "public_address" {
  value = "\${element(var.target_ips, 0)}"
}
EOF

# modules/master/input.tf
# modules/master/output.tf
# modules/master/master.tf
cat <<EOF >"${lplatform}/modules/master/input.tf"
variable "count" {}
variable "name" {}
variable "hostname_suffix" {}
variable "hostname_path" {}
variable "cloud_init" {}
variable "cpus" {}
variable "memory" {}
EOF

cat <<EOF >"${lplatform}/modules/master/output.tf"
output "master_ips" {
  # The expression that returns the list of IP addresses for the nodes
  # is provider dependent and will need to be modified for the provider.
  value = "\${join(",", ${lprovider}_machine.node.*.default_ip_address)}"
}
EOF

cat <<EOF >"${lplatform}/modules/master/master.tf"
resource "${lprovider}_machine" "node" {
  count = "\${var.count}"
  name  = "\${var.name}-master-\${count.index + 1}"
  
  cpus   = "\${var.cpus}"
  memory = "\${var.memory}"

  user_data = "\${element(split("\`", var.cloud_init), count.index)}"
}
EOF

# modules/worker/input.tf
# modules/worker/output.tf
# modules/worker/master.tf
cat <<EOF >"${lplatform}/modules/worker/input.tf"
variable "count" {}
variable "name" {}
variable "hostname_suffix" {}
variable "hostname_path" {}
variable "cloud_init" {}
variable "cpus" {}
variable "memory" {}
EOF

cat <<EOF >"${lplatform}/modules/worker/output.tf"
output "worker_ips" {
  # The expression that returns the list of IP addresses for the nodes
  # is provider dependent and will need to be modified for the provider.
  value = "\${join(",", ${lprovider}_machine.node.*.default_ip_address)}"
}
EOF

cat <<EOF >"${lplatform}/modules/worker/worker.tf"
resource "${lprovider}_machine" "node" {
  count = "\${var.count}"
  name  = "\${var.name}-worker-\${count.index + 1}"
  
  cpus   = "\${var.cpus}"
  memory = "\${var.memory}"

  user_data = "\${element(split("\`", var.cloud_init), count.index)}"
}
EOF

# provision.sh
if grep -qF 'END PROVIDERS - DO NOT REPLACE' <provision.sh; then
  sed -i'' -e 's~fi # END PROVIDERS - DO NOT REPLACE~~' provision.sh
  cat <<EOF >>provision.sh
elif [[ "\$CLOUD_CMD" = "${lplatform}-deploy" || \\
        "\$CLOUD_CMD" = "${lplatform}-destroy" ]] ; then

    cd \${DIR}/${lplatform}

    # initialize based on the config type
    if [ "\$BACKEND" = "s3" ] ; then
        cp ../s3-backend.tf .
        terraform init \\
            -backend-config "bucket=\${AWS_BUCKET}" \\
            -backend-config "key=${lplatform}-\${TF_VAR_name}" \\
            -backend-config "region=\${AWS_DEFAULT_REGION}"
    elif [ "\$BACKEND" = "file" ] ; then
        cp ../file-backend.tf .
        terraform init -backend-config "path=/cncf/data/\${TF_VAR_name}/terraform.tfstate"
    fi

    # deploy/destroy implementations
    if [ "\$CLOUD_CMD" = "${lplatform}-deploy" ] ; then
        terraform taint -module=kubeconfig null_resource.kubeconfig || true
        time terraform apply -auto-approve \${DIR}/${lplatform}
    elif [ "\$CLOUD_CMD" = "${lplatform}-destroy" ] ; then
        time terraform destroy -force \${DIR}/${lplatform} || true
        # Exit after destroying resources as further commands cause hang
        exit
    fi

    export KUBECONFIG=\${TF_VAR_data_dir}/kubeconfig
    _retry "❤ Trying to connect to cluster with kubectl" kubectl get cs
    _retry "❤ Ensure that the kube-system namespaces exists" kubectl get namespace kube-system
    _retry "❤ Ensure that ClusterRoles are available" kubectl get ClusterRole.v1.rbac.authorization.k8s.io
    _retry "❤ Ensure that ClusterRoleBindings are available" kubectl get ClusterRoleBinding.v1.rbac.authorization.k8s.io

    kubectl create -f /cncf/rbac/ || true
    kubectl create -f /cncf/addons/ || true

    KUBECTL_PATH=\$(which kubectl) NUM_NODES="\$TF_VAR_worker_node_count" KUBERNETES_PROVIDER=local \${DIR}/validate-cluster/cluster/validate-cluster.sh || true

# END ${platform}

fi # END PROVIDERS - DO NOT REPLACE

EOF
fi

# provision.sh
if grep -qF 'END PROVIDERS - DO NOT REPLACE' <Dockerfile; then
  sed -i'' -e 's~# END PROVIDERS - DO NOT REPLACE~COPY '"${lplatform}"'/ /cncf/'"${lplatform}"'/\
# END PROVIDERS - DO NOT REPLACE~' Dockerfile
fi

echo "success!"
echo
cat <<EOF
CONFIGURE THE TERRAFORM PROVIDER
  The Terraform provider for the new platform must be configured in
  ${lplatform}/providers.tf. Please see https://www.terraform.io/docs/providers/
  for a complete list of the Terraform providers and how to configure them.

CONFIGURE THE CONTROL PLANE NODES
  Please update the files in ${lplatform}/modules/master to match the
  configuration schema required by the specified platform's associated
  Terraform provider.

CONFIGURE THE WORKER NODES
  Please update the files in ${lplatform}/modules/worker to match the
  configuration schema required by the specified platform's associated
  Terraform provider.

CONFIGURE THE LOAD BALANCER (OPTIONAL)
  The skeleton includes files that describe a load balancer which simply
  returns the first IP address from the IP addresses of the control plane nodes.
  Any actual load balancer will be dependent upon the specified platform. Please
  update the files in ${lplatform}/modules/load_balancer to enable an actual,
  working load balancer.
EOF

if ! grep -qF 'END PROVIDERS - DO NOT REPLACE' <Dockerfile; then
cat <<EOF

UPDATE THE DOCKERFILE
  The Dockerfile must be updated to account for the new platform provider.
  Please find the section of the Dockerfile that copies the platform
  directories into the container image and append the following:

    COPY ${lplatform}/ /cncf/${lplatform}/
EOF
fi

if ! grep -qF 'END PROVIDERS - DO NOT REPLACE' <provision.sh; then
cat <<EOF

UPDATE THE PROVISION SCRIPT
  The file "provision.sh" must be updated to account for the new platform
  provider. At the end of the file please replace the final "fi" with an
  "elif" in accordance with the other platforms in the file.
EOF
fi
