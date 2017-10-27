# #Gen SSH KeyPair
# resource "null_resource" "ssh_gen" {

#   provisioner "local-exec" {
#     command = <<EOF
# mkdir -p ${ var.data_dir }/.ssh
# ssh-keygen -t rsa -f ${ var.data_dir }/.ssh/id_rsa -N ''
# EOF
#   }

#   provisioner "local-exec" {
#     when = "destroy"
#     on_failure = "continue"
#     command = <<EOF
#     rm -rf ${ var.data_dir }/.ssh
# EOF
#   }

#   provisioner "local-exec" {
#     command = <<EOF
#     packet admin -k ${ var.packet_api_key } create-sshkey --label ${ var.name } --file ${ var.data_dir}/.ssh/id_rsa.pub
# EOF
#   }

# }
