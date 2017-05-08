# output "fqdn-k8s" { value = "${ module.etcd.fqdn-lb}" }
# output "bastion-ip" { value = "${ module.bastion.bastion-ip}" }
# output "bastion-fqdn" { value = "${ module.bastion.bastion-fqdn}" }
# output "k8s-admin" { value = "${ k8s-admin}"}
# # fixme for use outside container
# output "ssh-key-setup" { value = "eval $(ssh-agent) ; ssh-add /cncf/data/.ssh/id_rsa"}
# output "ssh-via-bastion" { value = "ssh -At ${ var.admin_username }@${ module.bastion.bastion-fqdn } ssh ${ var.admin_username }@master1.cncf.demo"}

#output "availability-id" { value = "${ azurerm_availability_set.cncf.id }" }
#output "azs" { value = "${ var.aws["azs"] }" }
#output "bastion-ip" { value = "${ module.bastion.ip }" }
#output "cluster_domain" { value = "${ var.cluster_domain }" }
#output "dns-service-ip" { value = "${ var.dns_service_ip }" }
#output "etcd1-ip" { value = "${ element( split(",", var.etcd-ips), 0 ) }" }
output "external_lb" { value = "${ module.etcd.external_lb }" }
#output "internal_tld" { value = "${ var.internal_tld }" }
#output "name" { value = "${ var.name }" }
#output "region" { value = "${ var.aws["region"] }" }
#output "s3-bucket" { value = "${ var.s3-bucket }" }
#output "subnet-ids-private" { value = "${ module.vpc.subnet-ids-private }" }
#output "subnet-ids-public" { value = "${ module.vpc.subnet-ids-public }" }
#output "worker-autoscaling-group-name" { value = "${ module.worker.autoscaling-group-name }" }
output "kubeconfig" { value = "${ module.kubeconfig.kubeconfig }"}
