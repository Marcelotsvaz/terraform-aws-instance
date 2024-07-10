provider aws {
	default_tags {
		tags = {
			Project = local.project_name
		}
	}
}