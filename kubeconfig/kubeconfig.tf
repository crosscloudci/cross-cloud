data "template_file" "kubeconfig" {
  template = "${ file( "${ path.module }/kubeconfig" )}"

  vars {
    endpoint = "${ var.endpoint }"
    name = "${ var.name }"
    ca = "${ var.ca }"
    client = "${ var.client }"
    client_key = "${ var.client_key }"
  }
}

resource "null_resource" "file" {

  provisioner "local-exec" {
    command = <<LOCAL_EXEC
echo "${ data.template_file.kubeconfig.rendered }" > "kubeconfig"
LOCAL_EXEC
  }
}
