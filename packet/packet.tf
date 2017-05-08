# Configure the Packet Provider
# https://www.terraform.io/docs/providers/packet/index.html
# PACKET_AUTH_TOKEN must be set
# resource "packet_project" "cncf" {
#   name     = "${ var.name }"
#   # packet_project.cncf: Payment method can't be blank
#   payment_method = ""
# }

resource "packet_ssh_key" "cncf" {
  name     = "${ var.name }"
  public_key = "${file("${ var.data_dir }/.ssh/id_rsa.pub")}"
}

 # terraform {
#   backend "local" {
#     path = "${ var.data_dir}/terraform.tfstate"
#   }
# }
