# outputs
output "azs" { value = "${ var.aws_azs }" }
output "bastion_ip" { value = "${ module.bastion.ip }" }
output "cluster_domain" { value = "${ var.cluster_domain }" }
output "dns_service_ip" { value = "${ var.dns_service_ip }" }
output "external_elb" { value = "${ module.etcd.external_elb }" }
output "internal_tld" { value = "${ var.internal_tld }" }
output "name" { value = "${ var.name }" }
output "region" { value = "${ var.aws_region }" }
output "subnet_ids_private" { value = "${ module.vpc.subnet_ids_private }" }
output "subnet_ids_public" { value = "${ module.vpc.subnet_ids_public }" }
output "worker_autoscaling_group_name" { value = "${ module.worker.autoscaling_group_name }" }
output "ssh_key_setup" { value = "eval $(ssh-agent) ; ssh-add ${ var.data_dir}/${ var.name}.pem" }
output "ssh_via_bastion" { value = "ssh -At ${ var.admin_username }@${ module.bastion.ip } ssh ${ var.admin_username }@etcd1.${ var.internal_tld }"}
output "kubeconfig" { value = "${ module.kubeconfig.kubeconfig }"}
