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

################################## Naming convention variables #########################################

variable "bu" {
  description = "Business unit name (e.g., BP, GURUKU). Max 6 characters."
  type        = string
  default = "BP"
  validation {
    condition     = length(var.bu) <= 6
    error_message = "The business unit name must be less than or equal to 6 characters."
  }
}

variable "program" {
  description = "Name of the program (e.g., OT, BP)."
  type        = string
  default = "OT"
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string
  default = "network"
  validation {
    condition     = length(var.app) <= 10
    error_message = "The app name must be less than or equal to 10 characters."
  }
}

variable "env" {
  description = "Environment code: 'd' (dev), 'p' (prod), 'q' (qa), 's' (stage), 'g' (global)."
  type        = string
  default = "d"

  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "team" {
  description = "Team email responsible for the application (e.g., digitalops@gehealthcare.com)."
  type        = string
  default = "infra"
}

variable "region" {
  description = "AWS region (e.g., us-east-1, ap-south-1)."
  type        = string
  default = "us-east-1"
}
