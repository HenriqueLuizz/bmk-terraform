variable prefix { default = "bmk" }
variable instances { default = 20 }
variable shape_secondary { default = "VM.Standard.E4.Flex" } #"VM.Standard.A1.Flex"
variable instance_ocpus { default = 8 }
variable instance_memory { default = 128 }

variable region { default= "us-ashburn-1" }

variable ssh_file_public_key {default = "/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/chave_cloud_01.pub"}
variable ssh_private_key { default     = "/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/chave_cloud_01" }

variable subn_publica { default = "ocid1.subnet.oc1.iad.aaaaaaaaxn6idkm4x4f4bcs2u5vh3pzjyqrmywgq3jmis5nbeoh243ksbsua" }
variable subn_privada { default = "ocid1.subnet.oc1.iad.aaaaaaaawyz2kmpsw4hbjkp4fr7qzmo7dkq3da5f6h4w76coeb24vx7ppasa" }

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

