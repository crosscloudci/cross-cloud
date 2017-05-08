output "fqdn_k8s" { value = "endpoint.${ var.name }.${ var.domain }" }
# output "bastion_ip" { value = "${ module.bastion.bastion_ip}" }
# output "bastion_fqdn" { value = "${ module.bastion.bastion_fqdn}" }
# output "k8s_admin" { value = "${ k8s_admin}"}
# # fixme for use outside container
output "ssh_key_setup" { value = "eval $(ssh-agent) ; ssh-add ${ var.data_dir }/.ssh/id_rsa"}
output "ssh_first_master" { value = "ssh -At core@master1.${ var.name }.${ var.domain }" }
output "ssh_second_master" { value = "ssh -At core@master2.${ var.name }.${ var.domain }" }
output "ssh_third_master" { value = "ssh -At core@master3.${ var.name }.${ var.domain }" }
output "ssh_first_worker" { value = "ssh -At core@worker1.${ var.name }.${ var.domain }" }
output "ssh_second_worker" { value = "ssh -At core@worker2.${ var.name }.${ var.domain }" }
output "ssh_third_worker" { value = "ssh -At core@worker3.${ var.name }.${ var.domain }" }
# " ssh ${ var.admin_username }@etcd1.${ var.name }.${ var.domain }"}
output "kubeconfig" { value = "${ module.kubeconfig.kubeconfig }"}
