tls_ca_cert_subject_common_name = "CA"
tls_ca_cert_subject_organization = "Kubernetes"
tls_ca_cert_subject_locality = "San Francisco"
tls_ca_cert_subject_province = "California"
tls_ca_cert_subject_country = "US"
tls_ca_cert_validity_period_hours = 1000
tls_ca_cert_early_renewal_hours = 100

tls_etcd_cert_subject_common_name = "k8s-etcd"
tls_etcd_cert_validity_period_hours = 1000
tls_etcd_cert_early_renewal_hours = 100
tls_etcd_cert_dns_names = "etcd.k8sserure.cncf.demo,etcd1.k8sserure.cncf.demo,etcd2.k8sserure.cncf.demo,etcd3.k8sserure.cncf.demo"
tls_etcd_cert_ip_addresses = "127.0.0.1"

tls_client_cert_subject_common_name = "k8s-admin"
tls_client_cert_validity_period_hours = 1000
tls_client_cert_early_renewal_hours = 100
tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.*.compute.internal,*.ec2.internal"
tls_client_cert_ip_addresses = "127.0.0.1"

tls_apiserver_cert_subject_common_name = "k8s-apiserver"
tls_apiserver_cert_validity_period_hours = 1000
tls_apiserver_cert_early_renewal_hours = 100
tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,master.k8sserure.cncf.demo,*.ap-southeast-2.elb.amazonaws.com"
tls_apiserver_cert_ip_addresses = "127.0.0.1,10.3.0.1"

tls_worker_cert_subject_common_name = "k8s-worker"
tls_worker_cert_validity_period_hours = 1000
tls_worker_cert_early_renewal_hours = 100
tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,*.*.compute.internal,*.ec2.internal"
tls_worker_cert_ip_addresses = "127.0.0.1"
