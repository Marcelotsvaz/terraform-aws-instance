# 
# Naming
#-------------------------------------------------------------------------------
variable name {
	description = "Pretty name for resources in this module. Used in tags."
	type = string
}

variable prefix {
	description = "Unique prefix for resources that require a (possibly unique) name or identifier."
	type = string
	
	validation {
		condition = length( regexall( "^[a-z0-9_-]+$", var.prefix ) ) > 0
		error_message = "`prefix` should contain only lower case letters, numbers, hyphens and underscores."
	}
}