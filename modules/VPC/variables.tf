##############################################################
#  Variable Definitions 
#############################################################
###
variable "cloud_zone" {
    description = "Region of IBM Public Cloud to deploy"
}
###
variable "vpc_name" {
    description = "Denotes the name of the VPC to create"
    default     = "tftest-vpc01"
}
###
variable "subnet_name" {
    description = "Denotes the name of the subnet to create"
    default     = "tfest-subnet"
}
####
variable "ipv4_cidr_block" {
    description = "Denotes the CIDR block to create for the network subnet"
    default     = "10.240.128.0/24"
}
###
variable "ssh_key_label" {
    description = "The name of the SSHKEY that will be created"
    default     = "tf-sshkey"
}
###
variable "public_ssh_key" {
    description = "The file containing the public key"
    default     = "id_rsa.pub"
}
###
variable "resource_group" {
    description =  "The resource group to use for all the resources"
    default     = "  "
}
