data "template_file" "kubeconfig" {
  template = <<EOF
kubectl config set-cluster cluster-${ var.name } \
  --embed-certs \
  --server=https://${ var.endpoint } \
  --certificate-authority=${ var.ca }

kubectl config set-credentials admin-${ var.name } \
  --embed-certs \
  --certificate-authority=${ var.ca } \
  --client-key=${ var.client_key } \
  --client-certificate=${ var.client }

kubectl config set-context ${ var.name } \
  --cluster=cluster-${ var.name } \
  --user=admin-${ var.name }

kubectl config use-context ${ var.name }
EOF
}


resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
export KUBECONFIG="${ var.data_dir}/kubeconfig"

kubectl config set-cluster cluster-${ var.name } \
  --embed-certs \
  --server=https://${ var.endpoint } \
  --certificate-authority=${ var.ca } &&\
kubectl config set-credentials admin-${ var.name } \
  --embed-certs \
  --certificate-authority=${ var.ca } \
  --client-key=${ var.client_key } \
  --client-certificate=${ var.client } &&\
kubectl config set-context ${ var.name } \
  --cluster=cluster-${ var.name } \
  --user=admin-${ var.name } &&\
kubectl config use-context ${ var.name }
LOCAL_EXEC
  }

}
