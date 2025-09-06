variable "name" {
  description = "Name of the CloudTrail trail"
  type        = string
}

variable "enable_logging" {
  description = "Whether CloudTrail logging is enabled"
  type        = bool
  default     = true
}

variable "create_bucket" {
  description = "Whether to create a new S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Name of the existing S3 bucket (if create_bucket is false)"
  type        = string
  default     = ""
}

variable "s3_key_prefix" {
  description = "S3 key prefix for CloudTrail logs"
  type        = string
  default     = "cloudtrail"
}

variable "enable_log_file_validation" {
  description = "Enable log file integrity validation"
  type        = bool
  default     = true
}

variable "create_log_group" {
  description = "Whether to create CloudWatch log group and stream"
  type        = bool
  default     = true
}

variable "create_sns_topic" {
  description = "Whether to create a new SNS topic for CloudTrail"
  type        = bool
  default     = true
}

variable "sns_topic_name" {
  description = "SNS topic name (used when create_sns_topic is false)"
  type        = string
  default     = ""
}

variable "is_multi_region_trail" {
  description = "Whether this trail is multi-region"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Include global service events"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encryption (optional)"
  type        = string
  default     = ""
}

variable "is_organization_trail" {
  description = "Is this trail for an organization"
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
  type = list(object({
    include_management_events = bool
    read_write_type           = string
    data_resource = optional(list(object({
      type   = string
      values = list(string)
    })), [])
  }))
  default = []
}

variable "advanced_event_selector" {
  description = "Advanced event selector configuration"
  type = list(object({
    name = string
    field_selector = list(object({
      field           = string
      equals          = optional(list(string))
      starts_with     = optional(list(string))
      ends_with       = optional(list(string))
      not_equals      = optional(list(string))
      not_starts_with = optional(list(string))
      not_ends_with   = optional(list(string))
    }))
  }))
  default = []
}

variable "insight_selector" {
  description = "Insight selectors like ApiCallRateInsight"
  type        = list(string)
  default     = []
}

variable "force_destroy" {
  type = bool
  default = true
}

variable "block_public_acls" {
type = bool
default = true
}

variable "block_public_policy" {
  type = bool
  default = true
}

variable "ignore_public_acls" {
  type = bool
  default = true
}

variable "restrict_public_buckets" {
  type = bool
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