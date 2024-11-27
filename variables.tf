variable "resource_group_name" {
  description = "The resource group name"
  type        = string
  default     = "rg-springboot-react-project"
}

variable "location" {
  description = "The Azure Region were the resource should exist"
  type        = string
  default     = "westeurope"
}

variable "acr_name" {
  description = "Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
  type        = string
  default     = "acrspringbootreact"
}

variable "asp_name" {
  description = "The name which should be used for this Service Plan. Changing this forces a new Service Plan to be created."
  type        = string
  default     = "asp-springboot-react"
}

variable "insight_name" {
  description = "The Azure monitor insight"
  type        = string
  default     = "appi-springboot-react"
}

variable "lwapp_name" {
  description = "The name which should be used for this Linux Web App. Changing this forces a new Linux Web App to be created."
  type        = string
  default     = "lwapp-springboot-react"
}
