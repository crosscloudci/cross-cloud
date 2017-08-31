# resource "ibm_container_cluster" "testacc_cluster" {
#   name            = "test"
#   datacenter      = "dal10"
#   machine_type    = "free"
#   isolation       = "public"
#   public_vlan_id  = "vlan"
#   private_vlan_id = "vlan"
#   subnet_id       = ["1154643"]

#   workers = [{
#     name = "worker1"

#     action = "add"
#   }]
#   org_guid     = "cncf"
#   space_guid   = "test"
#   account_guid = "test_acc"
# }

# resource "null_resource" "file" {

#   provisioner "local-exec" {
#     command = <<LOCAL_EXEC
# echo "${ base64decode(google_container_cluster.cncf.master_auth.0.cluster_ca_certificate) }" > "${ var.data_dir }/ca.pem"
# echo  "${ base64decode(google_container_cluster.cncf.master_auth.0.client_certificate) }" > "${ var.data_dir }/k8s-admin.pem"
# echo "${ base64decode(google_container_cluster.cncf.master_auth.0.client_key) }" > "${ var.data_dir }/k8s-admin-key.pem"
# LOCAL_EXEC
#   }
# }
