

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


################################# Naming Convention Variables #########################################

variable "env" {
  description = "Environment short name. Must be one of: d (dev), p (prod), q (qa), s (stage), g (global)."
  type        = string
  default     = "d"
  validation {
    condition     = contains(["d", "p", "q", "s", "g"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's', 'g'."
  }
}

variable "bu" {
  description = "Business unit name (e.g., pcs, ultrasound). Max 5 characters."
  type        = string
  default     = "ot"
  validation {
    condition     = length(var.bu) <= 5
    error_message = "The business unit name must be less than or equal to 5 characters."
  }
}

variable "app" {
  description = "Application name (e.g., network, shared). Max 6 characters."
  type        = string
  default     = "bp"
  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}

variable "resource" {
  description = "Resource name (e.g., eks, efs, ecr). Max 15 characters."
  type        = string
  default     = "instance"
  validation {
    condition     = length(var.resource) <= 15
    error_message = "The resource name must be less than or equal to 15 characters."
  }
}

variable "tenant" {
  description = "Tenant name (e.g., app1, app2). Max 6 characters."
  type        = string
  default     = ""
  validation {
    condition     = length(var.tenant) <= 6
    error_message = "The tenant name must be less than or equal to 6 characters."
  }
}

variable "enabled_features" {
  type    = list(string)
  default = []
}

variable "random_alphanumeric_len" {
  description = "The length of random alphanumeric string desired. Min: 1, Max: 4."
  type        = number
  default     = 4
  validation {
    condition     = var.random_alphanumeric_len >= 1 && var.random_alphanumeric_len <= 4
    error_message = "The length must be between 1 and 4."
  }
}

variable "special" {
  description = "Include special characters like !@#$%&*()-_=+[]{}<>:? in the generated name."
  type        = bool
  default     = false
}

variable "upper" {
  description = "Include uppercase characters in the generated name."
  type        = bool
  default     = false
}

variable "number" {
  description = "Include numbers in the generated name."
  type        = bool
  default     = true
}

variable "gen_no_of_names" {
  description = "Number of names to generate."
  type        = number
  default     = 1
}

variable "team" {
  description = "The email address of the team who owns the application, ex:digitalops@gehealthcare.com"
  type        = string
  default     = "infra"
}

variable "program" {
  description = "Name of the Program, For ex: OT, BP etc."
  type        = string
  default     = "ot"
}


variable "region" {
  type    = string
  default = "us-east-1"
}