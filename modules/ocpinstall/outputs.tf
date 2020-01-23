output "web-console" {
  value = "https://${var.master_hostname}.${element(var.master_public_ips,0)}.nip.io:8443"
}
