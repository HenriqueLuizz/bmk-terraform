variable prefix { default = "bmk" }

variable shape_primary { default = "VM.Standard.E4.Flex" }
variable instance_ocpus { default = 8 }
variable instance_memory { default = 64 }

variable region { default= "us-ashburn-1" }

variable ssh_file_public_key { default = "/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/chave_cloud_01.pub" }
variable ssh_public_key { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbM/d+Y84sxxLHynDMr4dlgFMmcshdGY2OzCHogXjK14v23JUioVzX2577+pSmfa8OCmENatOoFvGYGjhNmUJ7NTk692KE+kWpqOkop+9EM2EMKEH9dFSpJ4iMRD+dFgmVqsyrKLxqKJgsdE8lO8aMmMmE/eCundvlcBr88XLkIzW7vcosxp3KdeSuWKhj1rykAxItQqb+nQcAlSqB+k01nMO6VKb8gIyXQoB1OkgoHtq7CoeCuWnELMuou2SOIXkIqHDlGSDsdQFY+KblnsXsJll1dG++t+plctohsyaBuZqjuKpS2NtbL8yY+uu+AYB3MND6ETJfipXcT0kDmzpZ raphaelcampelo@dhcp-10-159-36-107.vpn.oracle.com" }
variable ssh_private_key { default     = "/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/chave_cloud_01" }

variable source_id {
	type	= map
	default  = {
		"ARM" = "ocid1.image.oc1.iad.aaaaaaaadnc5jeyeslhvkvitrsqsx65z3x6vk4trycpaaeyl5fultqbjobdq",
		"X86_64" = "ocid1.image.oc1.iad.aaaaaaaa66sixgsmhurzb3g7jedimei4wzrsvuqxfteeeesgfsboyqwsb75q",
	}
}

variable OCI_AD {
	description = "Available AD's in OCI"
	type	= map
	default  = {
		"AD1" = "xvGe:US-ASHBURN-AD-1",
		"AD2" = "xvGe:US-ASHBURN-AD-2",
		"AD3" = "xvGe:US-ASHBURN-AD-3"
	}
}


# DATABASE VARIABLES
variable shape_db { default = "BM.DenseIO2.52" }
variable db_version { default = "19.0.0.0" }
variable db_name { default = "DBBMKXK" }
variable db_hostname { default = "BMDBBMKXK" }
variable db_ocpus { default = 14 }
variable db_percentage { default = 80 }
variable db_admin_password { default = "totvs#TOTVS#654" }
variable db_character_set { default = "WE8MSWIN1252" } 
variable db_ncharacter_set { default = "AL16UTF16"} #AL16UTF16 or UTF8
variable db_source { default = "NONE" }
variable db_edition { default = "ENTERPRISE_EDITION_HIGH_PERFORMANCE" }
variable db_license_model { default = "BRING_YOUR_OWN_LICENSE" }
variable db_time_zone { default = "America/Sao_Paulo" }
