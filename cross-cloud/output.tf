# outputs
output "aws_external_elb" { value = "${ module.aws.external_elb }" }
output "aws_internal_tld" { value = "${ module.aws.internal_tld }" }
# standardizing key locations would be nice
output "ssh_key_setup" { value = "eval $(ssh-agent) ; ssh-add ${ var.data_dir }/*/*.pem ;  ssh-add ${ var.data_dir}/*/.ssh/id_rsa" }
output "aws_bastion" { value = "${ module.aws.ssh_via_bastion }" }
output "azure_k8s_fqdn" { value = "${ module.azure.fqdn_k8s }" }
output "azure_bastion" { value = "${ module.azure.ssh_via_bastion }" }
output "kubeconfig" { value = "${ data.template_file.kubeconfig.rendered }" }
