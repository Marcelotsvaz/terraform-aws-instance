variables {
	name = "Instance"
	prefix = "instance_module-testing-instance"
}


run test_fulfilled {
	assert {
		condition = length( aws_ec2_fleet.main.fleet_instance_set ) == 1
		error_message = "`fleet_instance_set` must contain the launched instance data."
	}
	
	assert {
		condition = length( aws_ec2_fleet.main.fleet_instance_set[0].instance_ids ) == 1
		error_message = "`fleet_instance_set[0].instance_ids` must contain the launched instance ID."
	}
}