variable "prefix" {
  type        = string
  default     = "gcp"
  description = "prefixo"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "region"
}

variable "zone" {
  type        = string
  default     = "us-central1-c"
  description = "region zone"
}

variable "ports_allow" {
  type        = list
  default     = ["8080", "5432", "443", "5555", "10000-10020", "7890", "7900-7902", "9090"]
  description = "region zone"
}