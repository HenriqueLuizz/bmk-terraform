variable resource_group {
  type        = string
  default     = "rm-terraform"
  description = "bmkprotheus01"
}

variable resource_name {
  type        = string
  default     = "rm-terraform"
  description = "rm-terraform"
}

variable resource_location {
  type        = string
  default     = "East US 2"
  description = "East US 2"
}

variable prefix {
  type        = string
  default     = "BMK"
  description = "BMK"
}

variable location {
  type        = string
  default     = "East US 2"
  description = "location"
}

variable vm_name {
  type        = string
  default     = "BMKPROTHEUS"
  description = "BMKPROTHEUS"
}

variable vnet_name {
  type        = string
  default     = "bmk-network"
  description = "BMKPROTHEUS"
}

variable vnet_address_space {
  type = list(string)
  default     = ["10.0.0.0/16"] 
  description = "List of Address Spaces"
}

variable subnet_address_space {
  type        = string
  default     = "10.0.1.0/24"
  description = "location"
}
