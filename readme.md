Once your code reflects real names/IDs, run these commands:

Clusters
terraform import databricks_cluster.<existing_cluster1> <cluster-id-1>
terraform import databricks_cluster.<existing_cluster2> <cluster-id-2>

View current settings:

terraform state show databricks_cluster.<existing_cluster1>

Secret Scope
terraform import databricks_secret_scope.default <my-scope>

Secrets
terraform import databricks_secret.example_secret <my-scope>/<my-secret>

libraries
terraform import databricks_library.pypi_requests <cluster_id>/<library_id>


Groups & Users
terraform import databricks_group.example_group <group-id>
terraform import databricks_user.example_user <user-id>

permission
terraform import databricks_permissions.existing_cluster1_perms <cluster_id>

secret ACL 
terraform import databricks_secret_acl.data_engineers_manage <scope_name>|<principal>


SQL Warehouse
terraform import databricks_sql_endpoint.example_sql <warehouse-id>

Cluster Policy (if already exists)
terraform import databricks_cluster_policy.<cost_guardrails> <policy-id>


🔍 You can find IDs using:

Databricks UI URLs
databricks clusters list, databricks sql list-endpoints, etc.
Azure portal for workspace IDs.

🛑 Things You Don’t Import

Permissions (databricks_permissions): Just declare them. Terraform enforces them.
Libraries (databricks_library): Declare desired state; Terraform reconciles.
PATs (databricks_token): Only create new tokens, can’t import existing.

🚀 Final Steps

Run:
terraform plan
to confirm Terraform sees them as managed.

Then:

terraform apply
to enforce configuration.