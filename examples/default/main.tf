module instance {
	source = "../../"
	
	name = "Instance"
	prefix = "${local.project_prefix}-instance"
	
	role_policies = [ data.aws_iam_policy_document.main ]
}


data aws_iam_policy_document main {
	statement {
		actions = [ "ec2:DescribeInstances" ]
		resources = [ "*" ]
	}
}