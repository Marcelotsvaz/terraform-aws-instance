output arn {
	value = data.aws_instance.main.arn
	description = "Instance ARN."
}

output id {
	value = data.aws_instance.main.id
	description = "Instance ID."
}

output availability_zone {
	value = data.aws_instance.main.availability_zone
	description = "Availability zone where the instance was launched."
}

output private_ipv4 {
	value = data.aws_instance.main.public_ip
	description = "Private IPv4."
}

output public_ipv4 {
	value = data.aws_instance.main.public_ip
	description = "Public IPv4."
}

output public_ipv6 {
	value = one( data.aws_instance.main.ipv6_addresses )
	description = "Public IPv6."
}