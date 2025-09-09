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
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Get existing Databricks workspace
data "azurerm_databricks_workspace" "workspace" {
  name                = var.workspace_name
  resource_group_name = var.resource_group
}

# Databricks provider using SPN
provider "databricks" {
  azure_workspace_resource_id = data.azurerm_databricks_workspace.workspace.id
  azure_client_id             = var.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = var.tenant_id
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