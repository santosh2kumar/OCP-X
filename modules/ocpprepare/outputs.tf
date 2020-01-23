
output "prepare_complete" {
    depends_on  = ["null_resource.openshift_init"]
    description = "Boolean value that is set to true when all prepare steps are complete"
    value       = "true"
}
