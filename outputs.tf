#output "VM external IP address" {
#    value = "${ibm_is_floating_ip.fip_srv01.id}"
#}

output "web-console" {
  value = "${module.OCPInstall_ocp.web-console}"
}

output "admin-user" {
  value = "${var.ocp_admin_username}"
}

output "admin-password" {
  value = "${var.ocp_admin_password}"
}
