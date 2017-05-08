module "aws" {
  source       = "../aws"
  name         = "${ var.name }-aws"
  internal_tld = "${ var.name }-aws.cncf.demo"
  data_dir     = "${ var.data_dir }/aws"
}

module "azure" {
  source                    = "../azure"
  name                      = "${ var.name }azure"
  internal_tld = "${ var.name }-azure.cncf.demo"
  data_dir                  = "${ var.data_dir }/azure"
}

module "packet" {
  source                    = "../packet"
  name                      = "${ var.name }-packet"
  data_dir                  = "${ var.data_dir }/packet"
  packet_project_id         = "${ var.packet_project_id }"
}

module "gce" {
  source                    = "../gce"
  name                      = "${ var.name }-gce"
  data_dir                  = "${ var.data_dir }/gce"
}

module "gke" {
  source                    = "../gke"
  name                      = "${ var.name }-gke"
  data_dir                  = "${ var.data_dir}/gke"
}


resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
export KUBECONFIG="${ var.data_dir}/kubeconfig"
${ module.aws.kubeconfig }
${ module.azure.kubeconfig }
${ module.packet.kubeconfig }
${ module.gce.kubeconfig }
${ module.gke.kubeconfig }
LOCAL_EXEC
  }

}

data "template_file" "kubeconfig" {
  template = <<EOF
    ${ module.aws.kubeconfig } && ${ module.azure.kubeconfig } && ${ module.packet.kubeconfig } && ${ module.gce.kubeconfig } && ${ module.gke.kubeconfig }
# Run this command to configure your kubeconfig:
# eval $(terraform output kubeconfig)
EOF
}

