# outputs
output "bastion_ip" { value = "${ module.bastion.ip }" }
output "external_elb" { value = "${ module.etcd.external_elb }" }
output "name" { value = "${ var.name }" }
output "region" { value = "${ var.aws_region }" }
output "ssh_key_setup" { value = "eval $(ssh-agent) ; ssh-add ${ var.data_dir}/${ var.name}.pem" }
output "ssh_via_bastion" { value = "ssh -At ${ var.admin_username }@${ module.bastion.ip } ssh ${ var.admin_username }@etcd1.${ var.internal_tld }"}
output "kubeconfig" { value = "${ module.kubeconfig.kubeconfig }"}
