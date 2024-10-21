# Obtain via the following command: 
# az account list-locations --query "[].{regionalDisplayName: regionalDisplayName, name: name, displayName: displayName, pairedRegionName: metadata.pairedRegion[0].name}"
variable "location" {
  type        = string
  description = "Azure location"
  default     = "East US 2"
}

variable "name" {
  type        = string
  description = "Used in resource names"
  default     = "lab"
}
