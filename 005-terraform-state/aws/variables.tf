variable "location" {
  type        = string
  description = "Azure location"
  default     = "us-east-2"
}

variable "profile" {
  type        = string
  description = "Used in resource names"
  default     = "lab"
}
