#################################################
# Output
#################################################
output "infra_public_ip" {
  value = "${ibm_is_floating_ip.infra_fip.*.address}"
}

output "infra_private_ip" {
  value = "${ibm_is_instance.infra.*.primary_network_interface.0.primary_ipv4_address}"
}

output "infra_hostname" {
  value = "${ibm_is_instance.infra.*.name}"
}

