variable "prefix" {
  type        = string
  default     = "gcp"
  description = "prefixo"
}

variable "name" {
  type        = string
  default     = "disk"
  description = "name to disk"
}

variable "type" {
  type        = string
  default     = "pd-ssd"
  description = "disk type"
}

variable "size" {
  type        = number
  default     = 30
  description = "disk size"
}

variable "zone" {
  type        = string
  default     = "us-central1-c"
  description = "disk zone"
}

variable "label" {
  type        = string
  default     = "dev"
  description = "disk enviroment label"
}

variable "image" {
  type        = string
  default     = ""
  description = "disk image"
}