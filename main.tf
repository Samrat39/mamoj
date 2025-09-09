terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.34.0"
    }
  }
}

# Azure authentication
provider "azurerm" {
  features {}
  subscription_id = data.azurerm_key_vault_secret.subscription_id.value
  client_id       = data.azurerm_key_vault_secret.client_id.value
  client_secret   = data.azurerm_key_vault_secret.client_secret.value
  tenant_id       = data.azurerm_key_vault_secret.tenant_id.value
}

# Key Vault
data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

# Secrets
data "azurerm_key_vault_secret" "client_id" {
  name         = "client-id"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = "client-secret"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "tenant_id" {
  name         = "tenant-id"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "subscription_id" {
  name         = "subscription-id"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# Existing Databricks Workspace
data "azurerm_databricks_workspace" "workspace" {
  name                = var.workspace_name
  resource_group_name = var.resource_group
}

# Databricks Provider
provider "databricks" {
  azure_workspace_resource_id = data.azurerm_databricks_workspace.workspace.id
  azure_client_id             = data.azurerm_key_vault_secret.client_id.value
  azure_client_secret         = data.azurerm_key_vault_secret.client_secret.value
  azure_tenant_id             = data.azurerm_key_vault_secret.tenant_id.value
}

# Module Call
module "databricks_cluster" {
  source                 = "./modules/cluster"
  cluster_name           = var.cluster_name
  spark_version          = var.spark_version
  node_type_id           = var.node_type_id
  autotermination_minutes = var.autotermination_minutes
  num_workers            = var.num_workers
  spark_conf             = var.spark_conf
  custom_tags            = var.custom_tags
}