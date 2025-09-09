variable "workspace_name" {
  type        = string
  description = "Name of existing Databricks workspace"
}

variable "resource_group" {
  type        = string
  description = "Resource group containing the workspace"
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault name"
}

variable "key_vault_rg" {
  type        = string
  description = "Resource group containing Key Vault"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "spark_version" {
  type        = string
}

variable "node_type_id" {
  type        = string
}

variable "autotermination_minutes" {
  type    = number
  default = 30
}

variable "num_workers" {
  type    = number
  default = 1
}

variable "spark_conf" {
  type    = map(string)
  default = {}
}

variable "custom_tags" {
  type    = map(string)
  default = {}
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "workspace_name" {}
variable "resource_group" {}
