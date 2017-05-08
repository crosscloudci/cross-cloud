output "network" { value = "${ google_compute_network.cncf.self_link }" }
output "subnetwork" { value = "${ google_compute_subnetwork.cncf.self_link }" }
