variable "main_resource_group_name" {
    type = string
    default = "data-project-humidity-home-rg"
}

variable "project_name" {
    type = string
    default = "aksairflow"
}

variable "location" {
    type = string
    default = "West Europe"
}

variable "client_id" {
    type = string
    sensitive = true
}

variable "client_secret" {
    type = string
    sensitive = true
}

variable "tenant_id" {
    type = string
    sensitive = true
}

variable "subscription_id" {
    type = string
    sensitive = true
}

variable "storage_account_humiditydata_name" {
    type = string
    sensitive = true
}

variable "storage_account_humiditydata_container_name" {
    type = string
    sensitive = true
}

variable "postgresql_connection_string" {
    type = string
    sensitive = true
}

variable "node_pool_name" {
    type = string
    default = "default"
}

variable "aks_vm_size" {
    type = string
    default = "Standard_D4s_v3"
}

variable "aks_authorized_ip_ranges" {
    type = list(string)
    default = ["0.0.0.0/32"]
}

variable "aks_upgrades_channel" {
    type = string
    default = "stable"
}

variable "workspace" {
    type = string
}
