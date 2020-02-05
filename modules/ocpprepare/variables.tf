variable "master_count" {
    default = "0"
}
variable "infra_count" {
    default = "0"
}
variable "worker_count" {
    default = "0"
}
variable "master_private_ips" {
    type = "list"
    default = []
}
variable "infra_private_ips" {
    type = "list"
    default = []
}
variable "worker_private_ips" {
    type = "list"
    default = []
}
variable "master_public_ips" {
    type = "list"
    default = []
}
variable "infra_public_ips" {
    type = "list"
    default = []
}
variable "worker_public_ips" {
    type = "list"
    default = []
}
variable "master_hosts" {
    type = "list"
    default = []
}
variable "infra_hosts" {
    type = "list"
    default = []
}
variable "worker_hosts" {
    type = "list"
    default = []
}

variable "domain_name" {
    default = ""
}

variable "rhel_username" {
    default = "root"
}

variable "private_ssh_key" {
    description = "string cointainer the private key"
    default     = "id_rsa"
}
variable "public_ssh_key" {
    description = "string cointainer the public key"
    default     = "id_rsa"
}

variable "rhel_subscription_username" {}

variable "rhel_subscription_password" {}

variable "subscription_pool_list" {
   type = "list"
   default = ["8a85f9996ae5df64016b0f63776c482b"]
}
##
##
variable "docker_volume_size" {}

