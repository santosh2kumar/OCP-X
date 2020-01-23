variable "ibmcloud_api_key" {
    description = "Denotes the IBM Cloud API key to use"
    default = "myIBMCloudAPIKey"
}

variable "ibmcloud_generation" {
    description = "Denotes which generation of IBM Cloud to use (1 = classic; 2 = NextGen)"
    default     = "2"
}

variable "ibmcloud_region" {
    description = "Denotes which IBM Cloud region to connect to"
    default     = "us-south"
}

variable "ibmcloud_zone" {
    description = "Denotes which zone within the IBM Cloud region to create the VM in"
    default     = "us-south-3"
}

#################################################
##               End of variables              ##
#################################################

provider "ibm" {
    version          = ">= 0.17.3"
    ibmcloud_api_key = "${var.ibmcloud_api_key}"
    generation       = "${var.ibmcloud_generation}"
    region           = "${var.ibmcloud_region}"
}
