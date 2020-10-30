variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable secretfile {
  type        = string
  default     = "teste-de-carga-do-protheus-930b2dbd0159.json"
}

variable prefix {
  type        = string
  default     = "bmk"
  description = "prefixo"
}

variable instances {
    type    = number
    default = 3
}

variable instance_type {
  type        = string
  default     = "c2-standard-8"
  description = "type instance"
}

variable region {
  type        = string
  default     = "us-central1"
  description = "region"
}

variable zone {
  type        = string
  default     = "us-central1-c"
  description = "region zone"
}

variable image_disk {
  type        = string
  default     = "windows-server-2019-dc-v20201013"
  description = "os image disk"
}

variable disk_type {
    type    = string
    default = "pd-ssd"
    description = "disk type"
}

variable disk_os_size {
    type = number
    default = 120
    description = "size of os disk"
}

variable primary_disk_data_size {
    type = number
    default = 500
    description = "primary size of data disk"
}

variable matriz_disk_data_size {
    type = number
    default = 200
    description = "matriz size of data disk"
}