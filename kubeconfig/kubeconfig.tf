# data "template_file" "kubeconfig" {
#   template = "${ file( "${ path.module }/kubeconfig" )}"

#   vars {
#     endpoint = "${ var.endpoint }"
#     name = "${ var.name }"
#     ca = "${ var.ca }"
#     client = "${ var.client }"
#     client_key = "${ var.client_key }"
#   }
# }

# resource "null_resource" "file" {

#   provisioner "local-exec" {
#     command = <<LOCAL_EXEC
# echo "${ data.template_file.kubeconfig.rendered }" > "kubeconfigtemplate"
# LOCAL_EXEC
#   }
# }

resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
command = <<LOCAL_EXEC
kubectl config set-cluster cluster-${ var.name } \
--server=https://${ var.endpoint } \
--certificate-authority=ca.pem &&\
kubectl config set-credentials admin-${ var.name } \
--certificate-authority=ca.pem \
--client-key=client_key.pem \
--client-certificate=client.pem &&\
kubectl config set-context ${ var.name } \
--cluster=cluster-${ var.name } \
--user=admin-${ var.name } &&\
kubectl config use-context ${ var.name }
LOCAL_EXEC
  }

}
