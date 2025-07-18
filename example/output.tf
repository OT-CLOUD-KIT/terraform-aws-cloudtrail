output "cloudtrail_arn" {
  value       = module.cloudtrail.cloudtrail_arn
  description = "The ARN of the CloudTrail trail"
}

output "cloudwatch_log_group_name" {
  value       = module.cloudtrail.cloudwatch_log_group_name
  description = "The name of the CloudWatch Log Group"
}

output "s3_bucket_name" {
  value       = module.cloudtrail.s3_bucket_name
  description = "The name of the S3 bucket used by CloudTrail"
}

output "sns_topic_arn" {
  value       = module.cloudtrail.sns_topic_arn
  description = "The ARN of the SNS topic used by CloudTrail"
}
