#################################################
# Output
#################################################
output "master_public_ip" {
  value = "${ibm_is_floating_ip.master_fip.*.address}"
}

output "master_private_ip" {
  value = "${ibm_is_instance.master.*.primary_network_interface.0.primary_ipv4_address}"
}

output "master_hostname" {
  value = "${ibm_is_instance.master.*.name}"
}

