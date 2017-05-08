output "fqdn_k8s" { value = "${ module.etcd.fqdn_lb}" }
output "bastion_ip" { value = "${ module.bastion.bastion_ip}" }
output "bastion_fqdn" { value = "${ module.bastion.bastion_fqdn}" }
output "k8s_admin" { value = "${ k8s_admin}"}
# fixme for use outside container
output "ssh_key_setup" { value = "eval $(ssh-agent) ; ssh-add ${ var.data_dir }/.ssh/id_rsa"}
output "ssh_via_bastion" { value = "ssh -At ${ var.admin_username }@${ module.bastion.bastion_fqdn } ssh ${ var.admin_username }@etcd1.${ var.internal_tld }"}
output "kubeconfig" { value = "${ module.kubeconfig.kubeconfig }"}
