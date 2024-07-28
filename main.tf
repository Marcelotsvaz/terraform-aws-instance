# 
# Instance
#-------------------------------------------------------------------------------
data aws_instance main {
	instance_id = aws_ec2_fleet.main.fleet_instance_set[0].instance_ids[0]
}


resource aws_ec2_fleet main {
	type = "instant"
	terminate_instances = true
	
	target_capacity_specification {
		default_target_capacity_type = "spot"
		spot_target_capacity = 1
		total_target_capacity = 1
	}
	
	launch_template_config {
		launch_template_specification {
			launch_template_id = aws_launch_template.main.id
			version = aws_launch_template.main.default_version
		}
		
		dynamic override {
			for_each = var.subnet_ids
			
			content {
				subnet_id = override.value
			}
		}
	}
	
	tags = {
		Name = "${var.name} Fleet"
	}
	
	lifecycle {
		replace_triggered_by = [
			aws_launch_template.main.id,
			aws_launch_template.main.default_version,
			aws_iam_role.main.inline_policy,
		]
	}
}


resource aws_launch_template main {
	name = var.prefix
	update_default_version = true
	
	# Configuration.
	instance_type = var.instance_type
	# instance_requirements {
	# 	allowed_instance_types = data.aws_ec2_instance_types.main.instance_types
	# 	burstable_performance = "included"
	# 	vcpu_count { min = var.min_vcpu_count }
	# 	memory_mib { min = var.min_memory_gib * 1024 }
	# }
	image_id = data.aws_ami.main.id
	user_data = var.user_data_base64
	iam_instance_profile { arn = aws_iam_instance_profile.main.arn }
	
	# Network.
	vpc_security_group_ids = var.security_group_ids
	# source_dest_check = var.source_dest_check
	
	# Storage.
	block_device_mappings {
		device_name = "/dev/xvda"
		
		ebs {
			volume_size = var.root_volume_size
			encrypted = true
		}
	}
	ebs_optimized = true
	
	dynamic tag_specifications {
		for_each = {
			spot-instances-request = {
				Name = "${var.name} Spot Request"
			}
			instance = {
				Name = var.name
			}
			volume = {
				Name = "${var.name} Root Volume"
			}
		}
		
		content {
			resource_type = tag_specifications.key
			tags = merge( data.aws_default_tags.main.tags, tag_specifications.value )
		}
	}
	
	tags = {
		Name = "${var.name} Launch Template"
	}
}


data aws_default_tags main {}



# 
# AMI
#-------------------------------------------------------------------------------
data aws_ami main {
	owners = [ "amazon" ]
	most_recent = true
	
	filter {
		name = "name"
		values = [ "al2023-ami-2023.*" ]
	}
	
	filter {
		name = "architecture"
		values = [ "x86_64" ]
	}
}



# 
# Instance Profile
#-------------------------------------------------------------------------------
resource aws_iam_instance_profile main {
	name = var.prefix
	role = aws_iam_role.main.name
	
	tags = {
		Name = "${var.name} Instance Profile"
	}
}


resource aws_iam_role main {
	name = var.prefix
	assume_role_policy = data.aws_iam_policy_document.assume_role.json
	managed_policy_arns = []
	
	dynamic inline_policy {
		for_each = var.role_policies
		
		content {
			name = inline_policy.value.policy_id
			policy = inline_policy.value.json
		}
	}
	
	tags = {
		Name = "${var.name} Role"
	}
}


data aws_iam_policy_document assume_role {
	statement {
		sid = "ec2AssumeRole"
		principals {
			type = "Service"
			identifiers = [ "ec2.amazonaws.com" ]
		}
		actions = [ "sts:AssumeRole" ]
	}
}