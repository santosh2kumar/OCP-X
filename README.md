# ocp-by-terraform

## Overview
This repository provides Terraform templates / scripts used to create OCP v3.11 clusters on the Next Generation IBM Cloud (Genesis).  The initial focus is to support deploying these clusters on Power systems, however x86 is supported. The templates support clusters with 1-3 Master nodes, 1-n Infrastructure nodes, and 1-n worker nodes.

Shared storage support has not been included yet .. but is in plan.

## Setup 

You need to set the following variables before running the Terraform job. 

  - provider.tf
     - your cloud provider API key
  - variables.tf
     - Red Hat Subscription ID / password
     - Red Hat Subscription pool(s) id(s)
     - SSH public/private key file name --   id_rsa (private key)    id_rsa.pub  (corresponding public key) -- generate this ahead of time using "ssh-keygen"
     - the number master, infrastructure, and worker nodes   Note: currently only a single Master is supported
     - the VSI profile -- currently the default is the smallest profile -- depending on your planned OCP workload(s) you may want to use a larger profile for both  
       the OCP control plane components (master, infra) or just the workers
     - check the OS Image ID .. It needs to be a Red Hat ppc64le OS.  The Image ID's have been changing 
     
## Install Terraform
     - You must install version 0.11.4 (no later versions work with the plugin) 
     - https://www.terraform.io/downloads.html

## Installing the IBM Cloud - Gen 2 - Terraform Provider Plugin
  - https://github.com/IBM-Cloud/terraform-provider-ibm/releases
  - API information is located here ==> https://ibm-cloud.github.io/tf-ibm-docs/v0.17.6/
  - the binary file (terraform-provider-ibm-v0.xx.xx)  must be put in this directory:
    - on Linux:  ~/.terraform.d/plugins
    - on Windows: %APPDATA%\terraform.d\plugins 
      - note: I was having issues running Terraform + Provider Plugin on Windows.  

     
## Running the Terraform Job  

- run the setup.sh script to set the environment variables. Note that you can set the trace level  and trace log file (see            
  https://www.terraform.io/docs/internals/debugging.html)
- the variables.tfvars file is automatically loaded by Terraform, no need to explicitly call it out with the var-file parameter
- run ==> terraform version
(you should see the following ouput) 
--------------------------------------------
    +Terraform v0.11.4
    + provider.ibm v0.17.3
    + provider.null v2.1.2
    + provider.random v2.2.1
    + provider.template v2.1.2
Your version of Terraform is out of date! The latest version is 0.12.12. You can update by downloading from www.terraform.io/downloads.html

--------------------------------------------------------------------------------

- we know the version is out of date - -nothing can be done at this time to address that issue

- run ==> terraform apply
- in less then 60 seconds terraform should come back with a "plan" of what it's about to do -- you read the plan from the bottom up .. 
- you are prompted to enter "yes" to proceed -- anything else will end the job
- the job takes anywhere from 26 - 35 minutes to run.
- if your connection breaks .. don't panic .. you may be able to just re-enter ==> terraform apply  
  - Terraform is smart enough to resume where it left off ... However -- depending on where Terraform got interrupted in the entire process it may be better just to start over -- fresh run ...
- run ==> terraform destroy
- this will destroy your environment, removing all the resources that were created.
- there is a little bug where Terraform is not cleaning up the block storage allocations from it's internal "book keeping file" .. so 
  - delete the "terraform.tstate" and "terraform.backup" files from your local working directory.  (The block storage does get deleted on the IBM Cloud however)
- wait 5 minutes or so to make sure the Gen 2 Cloud has completed cleaning up all the resources that the TF script deleted
- start the job again ... run ==> terraform apply


## Notes:
- Trouble-shooting .. remember you can use the  "--target=" command line option on the terraform command to only build one component at a time -- like "single stepping" the provisioning.  For example:   
  ==>terraform apply --target=module.VirtualPrivateCloud   
.. would just provision the virtual private cloud and the associated supporting resources.

- Upcoming Enhancments
   - shared storage pools (between workers)  - there is some discussion going on right now since NFS is the only officially supported distributed file system supported by RedHat on Power.  We are exploring some other options.
# ocpBySchematics
# ocpBySchematics
