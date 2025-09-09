resource "databricks_cluster" "existing_cluster1" {
  cluster_name            = "existing-cluster-1"
  spark_version           = "13.3.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 60

  autoscale {
    min_workers = 2
    max_workers = 5
  }

  azure_attributes {
    availability = "ON_DEMAND_AZURE"
  }
}

resource "databricks_cluster" "existing_cluster2" {
  cluster_name            = "existing-cluster-2"
  spark_version           = "13.3.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 90

  autoscale {
    min_workers = 3
    max_workers = 6
  }

  azure_attributes {
    availability = "ON_DEMAND_AZURE"
  }
}

#######################
# Secret Scopes & Secrets
#######################
resource "databricks_secret_scope" "default" {
  name                     = "my-scope"
  initial_manage_principal = "users"
}

resource "databricks_secret" "example_secret" {
  key          = "my-secret"
  string_value = "PLACEHOLDER"
  scope        = databricks_secret_scope.default.name
}

#######################
# Users & Groups
#######################
resource "databricks_user" "example_user" {
  user_name = "PLACEHOLDER@company.com"
}

resource "databricks_group" "example_group" {
  display_name = "data-engineers"
}


#######################
# Jobs
#######################

resource "databricks_job" "example_job" {
  name = "daily-etl"

  existing_cluster_id = databricks_cluster.existing_cluster.id

  notebook_task {
    notebook_path = "/Shared/etl-job"
  }
}

#######################
# Cluster Policies  
#######################

resource "databricks_cluster_policy" "existing_policy" {
  name = "existing-policy"
}


#######################
# Libraries
#######################

# Attach a PyPI library to an existing cluster
resource "databricks_library" "pypi_requests" {
  cluster_id = databricks_cluster.existing_cluster1.id
  pypi {
    package = "requests==2.31.0"
  }
}

# Attach a Maven coord (example)
resource "databricks_library" "maven_spark_avro" {
  cluster_id = databricks_cluster.existing_cluster1.id
  maven {
    coordinates = "org.apache.spark:spark-avro_2.12:3.5.1"
  }
}

######################
#permissions
#######################
# Give a group control over an existing cluster
resource "databricks_permissions" "existing_cluster1_perms" {
  cluster_id = databricks_cluster.existing_cluster1.id

  access_control {
    group_name       = "data-engineers"
    permission_level = "CAN_MANAGE"
  }

  access_control {
    group_name       = "data-analysts"
    permission_level = "CAN_RESTART"
  }
}

# Secret scope ACLs
resource "databricks_secret_acl" "data_engineers_manage" {
  scope      = databricks_secret_scope.default.name
  principal  = "data-engineers"
  permission = "MANAGE"
}

resource "databricks_secret_acl" "data_analysts_read" {
  scope      = databricks_secret_scope.default.name
  principal  = "data-analysts"
  permission = "READ"
}

# SQL Warehouse ACLs

resource "databricks_secret_acl" "sql_analysts_read" {
  scope      = databricks_secret_scope.default.name
  principal  = "sql"
  permission = "READ"
}

#######################
# Personal Access Tokens (PATs)
#######################

# Creates a long-lived PAT for CI/CD (adjust lifetime as needed)
resource "databricks_token" "ci" {
  comment          = "ci-terraform"
  lifetime_seconds = 31536000 # 365 days
}

# (Optional) Output token once – treat as highly sensitive
output "ci_pat_token_value" {
  value     = databricks_token.ci.token_value
  sensitive = true
}



#######################
# SQL Warehouse (Optional)
#######################
resource "databricks_sql_endpoint" "example_sql" {
  name                      = "analytics-warehouse"
  cluster_size              = "Small"
  max_num_clusters          = 1
  auto_stop_mins            = 30
  enable_serverless_compute = true # if available in your workspace/region

}

#######################
# New Cluster (Optional)
#######################
# (Optional) Attach the policy to an new cluster
#######################

# (Optional) Apply the policy to a new cluster you create via Terraform
# resource "databricks_cluster" "new_cluster" {
#   cluster_name  = "my-azure-cluster"
#   policy_id     = databricks_cluster_policy.cost_guardrails.id
#   spark_version = "13.3.x-scala2.12"
#   node_type_id  = "Standard_DS3_v2"

#   autotermination_minutes = 60
#   autoscale { min_workers = 2  max_workers = 5 }

#   azure_attributes {
#     availability       = "ON_DEMAND_AZURE"
#     first_on_demand    = 1
#     spot_bid_max_price = -1
#   }
#}

#######################
# policies (Optional)
#######################

resource "databricks_cluster_policy" "my_policy" {
  name        = "my-new-policy"
  description = "Policy to control cluster creation for cost and compliance"

  # Define the rules
  definition = jsonencode({
    "spark_version" = {
      "type"    = "allow"
      "values"  = ["13.3.x-scala2.12", "12.2.x-scala2.12"]
    },
    "node_type_id" = {
      "type"   = "allow"
      "values" = ["Standard_DS3_v2", "Standard_DS4_v2"]
    },
    "autoscale" = {
      "type" = "fixed"
      "value" = null
    },
    "autotermination_minutes" = {
      "type"  = "range"
      "min"   = 30
      "max"   = 120
    }
  })
}
