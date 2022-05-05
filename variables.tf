variable "name" {
  type        = string
  default     = "cloudtrail"
  description = "Name of the cloudtrail"
}

variable "enable_log_file_validation" {
  type        = bool
  default     = true
  description = "Specifies whether log file integrity validation is enabled. Creates signed digest for validated contents of logs"
}

variable "is_multi_region_trail" {
  type        = bool
  default     = false
  description = "Specifies whether the trail is created in the current region or in all regions"
}

variable "include_global_service_events" {
  type        = bool
  default     = false
  description = "Specifies whether the trail is publishing events from global services such as IAM to the log files"
}

variable "enable_logging" {
  type        = bool
  default     = true
  description = "Enable logging for the trail"
}

variable "create_bucket" {
  type = bool
  default = true
  description = "If true, it will create a new bucket with policy. If false, you will have to pass a bucket name"
}

variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "Provide S3 bucket name for CloudTrail logs if you specify create_bucket=false"
}

variable "s3_key_prefix" {
  type        = string
  default     = null
  description = "S3 bucket prefix for CloudTrail logs"
}

variable "event_selector" {
  type = list(object({
    include_management_events = bool
    read_write_type           = string

    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))

  description = "Specifies an event selector for enabling data event logging. Conflicts with advanced_event_selector"
  default     = []
}

variable "advanced_event_selector" {
  description = "specifies an advanced event selector for enabling data event logging. Conflicts with event_selector"

  validation {
    condition = length(setsubtract(toset(flatten([for i in var.advanced_event_selector: [for j in i.field_selector: j.field]])),["readOnly", "eventSource", "eventName", "eventCategory", "resources.type", "resources.ARN"])) == 0
    error_message = "Error: Field should be one of readOnly, eventSource, eventName, eventCategory, resources.type, resources.ARN ."
  }

  default = []
}

variable "kms_key_arn" {
  type        = string
  description = "The KMS key ARN to use to encrypt the logs delivered by CloudTrail"
  default     = ""
}

variable "is_organization_trail" {
  type        = bool
  default     = false
  description = "The trail is an AWS Organizations trail"
}

variable "sns_topic_name" {
  type        = string
  description = "Specifies the name of the Amazon SNS topic defined for notification of log file delivery"
  default     = null
}

variable "tags" {
  type = map
  description = "Tags for Cloudtrail"
  default     = {}
}

variable "insight_selector" {
  type = map
  default = {}
}

variable "create_log_group" {
  default = "true"
  type = bool
  description = "If this is provided, cloudtrail will be configured with cloudwatch logging."
}
