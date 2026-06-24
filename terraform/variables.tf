variable "location" {
  default = "eastus"
}

variable "resource_group_name" {
  default = "rg-devsu-devops-demo"
}

variable "acr_name" {
  description = "Globally unique ACR name"
  type        = string
  default     = "acrdevsufdecfec5"
}

variable "aks_name" {
  default = "aks-devsu-devops-demo"
}

variable "node_count" {
  default = 2
}
