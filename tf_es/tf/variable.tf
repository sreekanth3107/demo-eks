variable "region" {
  default = "us-east-1"
}

variable "domain_name" {
  type        = string
  default     = "imncore-elasticsearch"
  description = "name of Elasticsearch Domain"
}

variable "elasticsearch_version" {
  type        = string
  default     = "6.7"
  description = "Version of Elasticsearch to deploy"
}

variable "instance_type" {
  type        = string
  default     = "t2.medium.elasticsearch"
  description = "Elasticsearch instance type for data nodes in the cluster"
}

variable "instance_count" {
  type        = number
  description = "Number of data nodes in the cluster"
  default     = 2
}

variable "zone_awareness_enabled" {
  type        = bool
  default     = true
  description = "Enable zone awareness for Elasticsearch cluster"
}

variable "availability_zone_count" {
  type        = number
  default     = 2
  description = "Number of Availability Zones for the domain to use."
}

variable "ebs_volume_size" {
  type        = number
  description = "EBS volumes for data storage in GB"
  default     = 20
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp2"
  description = "Storage type of EBS volumes"
}

variable "ebs_iops" {
  type        = number
  default     = 0
  description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type"
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable encryption at rest"
}

variable "encrypt_at_rest_kms_key_id" {
  type        = string
  default     = ""
  description = "The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key"
}

variable "log_publishing_index_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not"
}

variable "log_publishing_search_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for SEARCH_SLOW_LOGS is enabled or not"
}

variable "log_publishing_application_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for ES_APPLICATION_LOGS is enabled or not"
}

variable "log_publishing_index_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for INDEX_SLOW_LOGS needs to be published"
}

variable "log_publishing_search_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for SEARCH_SLOW_LOGS needs to be published"
}

variable "log_publishing_application_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for ES_APPLICATION_LOGS needs to be published"
}

variable "automated_snapshot_start_hour" {
  type        = number
  description = "Hour at which automated snapshots are taken, in UTC"
  default     = 0
}

variable "dedicated_master_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
}

variable "dedicated_master_count" {
  type        = number
  description = "Number of dedicated master nodes in the cluster"
  default     = 0
}

variable "dedicated_master_type" {
  type        = string
  default     = "t2.large.elasticsearch"
  description = "Instance type of the dedicated master nodes in the cluster"
}

variable "advanced_options" {
  type        = map(string)
  default     = {}
  description = "Key-value string pairs to specify advanced configuration options"
}


variable "node_to_node_encryption_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable node-to-node encryption"
}

variable "stage" {
  default     = "dev"
  type        = string
  description = "stage name used as part of resource names. prod, dev, qa. this is populated by the ci pipeline"
}
variable "es_subnets" {
  type = "string"
  default = "subnet-d7dfb09e"
  description = "List of VPC Subnet IDs to create ElasticSearch Endpoints in"
}
variable "es1_subnets" {
  type = "string"
  default = "subnet-1370c048"
  description = "List of VPC Subnet IDs to create ElasticSearch Endpoints in"
}
variable "vpc" {
  type = "string"
  default = "vpc-0c0efd6a"
  description = "VPC ID where to launch ElasticSearch cluster"
}
variable "vpc_cidr" {
  type = "string"
  default = "10.0.0.0/8"
  description = "CIDR to allow connections to ElasticSearch"
}
variable "es_domain" {
  type = "string"
  default = "imncore-elastics"
  description = "ElasticSearch domain name"
}
