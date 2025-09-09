variable "cluster_name" {
  type        = string
  description = "Databricks cluster name"
}

variable "spark_version" {
  type        = string
  description = "Spark runtime version"
}

variable "node_type_id" {
  type        = string
  description = "VM type for nodes"
}

variable "autotermination_minutes" {
  type        = number
  description = "Auto-termination time"
  default     = 30
}

variable "num_workers" {
  type        = number
  description = "Number of workers"
  default     = 1
}

variable "spark_conf" {
  type        = map(string)
  default     = {}
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
}