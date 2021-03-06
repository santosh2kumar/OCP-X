##############################################################
#  Variable Definitions 
#############################################################
#################################################
# Common Variables
#################################################
###
variable "datacenter" {
    description = "Datacenter supplying storage"
    default     = "dal03"
}
###
variable "hourly_billing" {
  default = "true"
}

#################################################
# Worker Node Variables
#################################################
###
variable "cloud_zone" {
    description = "Region of IBM Public Cloud to deploy"
}
####
variable "resource_group"  {
    description = "resource group to allocate resources from"
}
###
variable "worker_hostname_prefix" {
    description = "prefix used to group hosts by functionality"
    default     = "tftest"
}
###
variable "worker_hostname" {
    description = "prefix used to group hosts by functionality"
    default     = "ocpworker"
}
###
variable "worker_count" {
    description = "number of worker nodes to generate"
    default     = "1"
}
###
variable "worker_image_id" {
    description = "the OS image ID that will be loaded on this server"
    default = "f9ca5c07-e540-4c73-a4a7-c4784f0fae4b"
}
###
variable "worker_profile_id" {
    description = "the CPU / RAM / Bandwidth profile to be used for this VM"
    default = "mp-2x16"
}
###
variable "worker_fip_name" {
    description = "The name that will be used for the floating IP resource"
    default = "semple-tftest-fip"
}   
###
variable "vpc_id" {
    description = "The VPC ID"
}
###
variable "vpc_subnet_id" {
    description = "The ID of the subnet associated with the VPC"
}
###
variable "ssh_key_id" {
    description = "The ID of the SSH Key associated with the VPC"
}
############################
###########################
####  Storage Related 
##
variable "worker_docker_volume_prefix" {
     description = "A prefix to put in front of the docker volume allocated for the OCP Worker Node"
}
variable "worker_docker_volume_size" {
     description = "Size in GB for docker volume"
}
