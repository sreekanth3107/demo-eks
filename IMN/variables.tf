variable "application_tags" {
  type        = map(any)
  description = "List of application tags to include with all resources supporting tags.  Note you do NOT need to include a Name tag, nor the APP_ID or COST_CENTER tags, since these are all added automatically by the module.  Please see [Tagging Strategies](https://wiki.healthcareit.net/display/IMNRD/Tagging+Strategies) for details on tagging."
  default     = {}
}

variable "app_id" {
  type        = string
  description = "AppId assigned by InfoSec for the application"
}

variable "cost_center" {
  type        = string
  description = "Cost center assigned for billing"
}

variable "team" {
  type        = string
  description = "the team name to be used as part of resource names"
}

variable "stage" {
  type        = string
  description = "stage name used as part of resource names. prod, dev, qa"
}

variable "business_domain" {
  description = "The business domain of the service. claims, eligiblity, etc"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Elasticsearch cluster"
  type        = string
  default     = "es-domain"
}

variable "es_version" {
  description = "Version of Elasticsearch to deploy (default 5.1)"
  type        = string
  default     = "5.1"
}

variable "instance_type" {
  description = "ES instance type for data nodes in the cluster (default t2.small.elasticsearch)"
  type        = string
  default     = "t2.small.elasticsearch"
}

variable "instance_count" {
  description = "Number of data nodes in the cluster (default 6)"
  type        = number
  default     = 6
}

variable "dedicated_master_type" {
  description = "ES instance type to be used for dedicated masters (default same as instance_type)"
  type        = string
  default     = "false"
}

variable "encrypt_at_rest" {
  description = "Enable encrption at rest (only specific instance family types support it: m4, c4, r4, i2, i3 default: false)"
  type        = bool
  default     = false
}

variable "encrypt_at_rest_kms_key_id" {
  type        = string
  default     = ""
  description = "The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key"
}

variable "iam_role_arns" {
  type        = list(string)
  default     = []
  description = "List of IAM role ARNs to permit access to the Elasticsearch domain"
}

variable "allowed_cidr_blocks" {
  description = "List of IP addresses from which to permit traffic (default []).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access."
  type        = list(string)
  default     = []
}

variable "es_zone_awareness" {
  description = "Enable zone awareness for Elasticsearch cluster (default false)"
  type        = bool
  default     = false
}

variable "es_zone_awareness_count" {
  description = "Number of availability zones used for data nodes (default 2)"
  type        = number
  default     = 2
}

variable "ebs_volume_size" {
  description = "Optionally use EBS volumes for data storage by specifying volume size in GB (default 0)"
  type        = number
  default     = 0
}

variable "ebs_volume_type" {
  description = "Storage type of EBS volumes, if used (default gp2)"
  type        = string
  default     = "gp2"
}

variable "snapshot_start_hour" {
  description = "Hour at which automated snapshots are taken, in UTC (default 0)"
  type        = number
  default     = 0
}

variable "vpc_id" {
  description = "The VPC to allocate resources in."
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
  default     = []
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security group IDs to be allowed to connect to the cluster"
}

variable "iam_actions" {
  type        = list(string)
  default     = []
  description = "List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`"
}

variable "dedicated_master_threshold" {
  description = "The number of instances above which dedicated master nodes will be used. Default: 10"
  type        = number
  default     = 10
}

variable "advanced_options" {
  description = "Map of key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply."
  type        = map(string)
  default     = {}
}

variable "log_publishing_options" {
  description = "List of maps of options for publishing slow logs to CloudWatch Logs."
  type        = list(map(string))
  default     = []
}

variable "node_to_node_encryption_enabled" {
  description = "Whether to enable node-to-node encryption."
  type        = bool
  default     = false
}

variable "ingress_from_port" {
  description = "Security group ingress rule from port."
  type        = number
  default     = 0
}

variable "ingress_to_port" {
  description = "Security group ingress rule to port."
  type        = number
  default     = 65535
}