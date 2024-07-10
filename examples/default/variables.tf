locals {
	project_name = "Instance Module Example"
	project_identifier = "instance_module_example"
	project_prefix = "${local.project_identifier}-${local.environment}"
	environment = "development"
}