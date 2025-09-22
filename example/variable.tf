

variable "name" {
  description = "Name of the CloudTrail trail"
  type        = string
}

variable "create_bucket" {
  description = "Whether to create a new S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Custom S3 bucket name (used if create_bucket is false)"
  type        = string
  default     = ""
}

variable "s3_key_prefix" {
  description = "Prefix for CloudTrail logs in the S3 bucket"
  type        = string
  default     = "cloudtrail"
}

variable "enable_logging" {
  description = "Enable CloudTrail logging"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Enable log file integrity validation"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Create a multi-region CloudTrail trail"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Include global service events"
  type        = bool
  default     = true
}

variable "create_log_group" {
  description = "Whether to create CloudWatch Log Group"
  type        = bool
  default     = true
}

variable "create_sns_topic" {
  description = "Whether to create SNS topic"
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "SNS topic name"
  type        = string
  default     = "cloudtrail-topic"
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting logs"
  type        = string
  default     = ""
}

variable "is_organization_trail" {
  description = "Whether this trail is an AWS Organizations trail"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "event_selector" {
  description = "Event selector configuration"
  type        = any
  default     = []
}

variable "advanced_event_selector" {
  description = "Advanced event selector configuration"
  type        = any
  default     = []
}

variable "insight_selector" {
  description = "Insight selector configuration"
  type        = list(string)
  default     = []
}

variable "force_destroy" {
  type    = bool
  default = true
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}


variable "owner" {
 type = string
 default = "opstree"
}

variable "env" {
  type = string
  default = "dev"
}

variable "app" {
  type = string
  default = "otcloud-kit"
}

variable "region" {
  type    = string
  default = "us-east-1"
}