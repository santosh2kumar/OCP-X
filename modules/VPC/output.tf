#################################################
# Output
#################################################
output "vpc_subnet_id" {
    value = "${ibm_is_subnet.subnet.id}"
}
##
output "vpc_id" {
    value = "${ibm_is_vpc.vpc.id}"
}
##
output "ssh_key_id" {
    value = "${ibm_is_ssh_key.sshkey.id}"
}
