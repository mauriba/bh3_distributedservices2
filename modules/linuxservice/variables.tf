variable "subnet" {
  type = object({
    id               = string
    address_prefixes = list(string)
  })
  nullable    = false
  description = "The subnet to deploy the Linux Service in"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "The resource group to deploy the Linux Service in"
}

variable "hostname" {
  type        = string
  nullable    = false
  description = "The hostname for the Linux Service VM"
}

variable "private_ip" {
  type        = string
  nullable    = true
  description = "The private IP address to assign to the Linux Service VM"
}

variable "enable_public_ip" {
  description = "If true, a public IP address will be associated with the Linux Service"
  type        = bool
  default     = false
}

variable "password" {
  type        = string
  description = "The password for the Linux Service VM"
  sensitive   = true
}

variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts" 
    sku       = "minimal"
    version   = "latest"
  }
  description = "The image to use for the Linux Service VM"
}
