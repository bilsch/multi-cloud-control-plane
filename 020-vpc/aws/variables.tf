variable "profile" {
  type        = string
  description = "Used in resource names"
  default     = "lab"
}

variable "enable_flow_log" {
  type        = bool
  description = "Passed to vpc module. Toggle vpc flow logs"
  default     = true
}

variable "enable_ipv6" {
  type        = bool
  description = "Toggle to enable ipv6 support"
  default     = true
}
