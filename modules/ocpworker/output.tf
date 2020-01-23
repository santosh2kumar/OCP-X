#################################################
# Output
#################################################
output "worker_public_ip" {
  value = "${ibm_is_floating_ip.worker_fip.*.address}"
}

output "worker_private_ip" {
  value = "${ibm_is_instance.worker.*.primary_network_interface.0.primary_ipv4_address}"
}

output "worker_hostname" {
  value = "${ibm_is_instance.worker.*.name}"
}

