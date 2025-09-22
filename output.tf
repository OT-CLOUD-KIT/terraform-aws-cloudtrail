output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.default.arn
}

output "s3_bucket_name" {
  description = "S3 bucket used for storing CloudTrail logs"
  value       = local.bucket_name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Log Group used by CloudTrail (if enabled)"
  value       = var.create_log_group ? aws_cloudwatch_log_group.log_group[0].name : null
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic (if created)"
  value       = var.create_sns_topic ? aws_sns_topic.cloudtrail_sns[0].arn : null
}
