workspace_name          = "my-databricks-workspace"
resource_group          = "my-resource-group"
key_vault_name          = "my-keyvault"
key_vault_rg            = "my-resource-group"

cluster_name            = "dev-cluster"
spark_version           = "13.3.x-scala2.12"
node_type_id            = "Standard_DS3_v2"
autotermination_minutes = 30
num_workers             = 2