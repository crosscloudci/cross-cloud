output "fqdn_k8s" { value = "${ module.master.fqdn_lb}" }
# output "bastion_ip" { value = "${ module.bastion.bastion_ip}" }
# output "bastion_fqdn" { value = "${ module.bastion.bastion_fqdn}" }
output "ssh_key_setup" { value = "eval $(ssh-agent) ; ssh-add ${ var.data_dir }/.ssh/id_rsa"}
# output "ssh_via_bastion" { value = "ssh -At ${ var.admin_username }@${ module.bastion.bastion_fqdn } ssh ${ var.admin_username }@azure-master1"}
