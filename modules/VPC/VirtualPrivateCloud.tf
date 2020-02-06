############################################################
# Resource Definitions
###########################################################
#
#
# Define the VPC
# -------------
resource "ibm_is_vpc" "vpc" {
    name = "${var.vpc_name}"
    resource_group = "${var.resource_group}"
}
#
# --
# Define the subnet
# -----------------
resource "ibm_is_subnet" "subnet" {
    name            = "${var.subnet_name}"
    vpc             = "${ibm_is_vpc.vpc.id}"
    zone            = "${var.cloud_zone}"
    ip_version      = "ipv4"
    ipv4_cidr_block = "${var.ipv4_cidr_block}"
}

# Define the  ssh key
# ----------------------
resource "ibm_is_ssh_key" "sshkey" {
    name       = "${var.ssh_key_label}"
    public_key = "${var.public_ssh_key}"
}
#
#
#
# Open up Ports in the Security Group associated with this Subnet
#
#--
# Define a rules to the def security group that got created with the VPC
# ---------------------------------------------------------------------
# allow  ssh - port 22  inbound
#
resource "ibm_is_security_group_rule" "sg1-tcp-fw-rule01" {
    group      = "${ibm_is_vpc.vpc.default_security_group}"
    direction  = "inbound"
    remote     = "0.0.0.0/0"

    tcp = {
        port_min = 22
        port_max = 22
        }
}
# allow  8443 for OCP Web Admin
#
resource "ibm_is_security_group_rule" "sg1-tcp-fw-rule02" {
    group      = "${ibm_is_vpc.vpc.default_security_group}"
    direction  = "inbound"
    remote     = "0.0.0.0/0"

    tcp = {
        port_min = 8443
        port_max = 8443
        }
}
# allow  80 for ingress controller - non-secure 
#
resource "ibm_is_security_group_rule" "sg1-tcp-fw-rule03" {
    group      = "${ibm_is_vpc.vpc.default_security_group}"
    direction  = "inbound"
    remote     = "0.0.0.0/0"

    tcp = {
        port_min = 80
        port_max = 80
        }
}
# allow  443  for OCP's cluster Console
#
# allow  80 for ingress controller - non-secure 
#
resource "ibm_is_security_group_rule" "sg1-tcp-fw-rule04" {
    group      = "${ibm_is_vpc.vpc.default_security_group}"
    direction  = "inbound"
    remote     = "0.0.0.0/0"

    tcp = {
        port_min = 443
        port_max = 443
        }
}
