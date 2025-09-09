terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.34.0"
    }
  }
}
provider "databricks" {
  client_id = "fdjnnsdnfjsd-xxxx-xxxx-xxxx-xxxxxxxxxx"
  client_secret = "djkandlkdlkamdlkamdlma"
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
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