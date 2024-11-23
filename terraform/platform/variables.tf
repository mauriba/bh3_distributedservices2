variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string 
}

variable "location" {
  description = "The location of all resources deployed by this configuration"
  type        = string
  default     = "northeurope"
}

variable "stage" {
  description = "The stage of the environment"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "prd", "qas"], var.stage)
    error_message = "Stage must be either dev, prd or qas"
  }
}
