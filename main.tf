resource "aws_cloudtrail" "default" {
  name                          = var.name
  enable_logging                = var.enable_logging
  s3_bucket_name                = var.s3_bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  enable_log_file_validation    = var.enable_log_file_validation
  sns_topic_name                = var.sns_topic_name
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn
  cloud_watch_logs_group_arn    = var.cloud_watch_log_group_name != "" ? "${aws_cloudwatch_log_group.log_group[0].arn}:*" : ""
  tags                          = var.tags
  kms_key_id                    = var.kms_key_arn
  is_organization_trail         = var.is_organization_trail

  dynamic "event_selector" {
    for_each = var.event_selector
    content {
      include_management_events = lookup(event_selector.value, "include_management_events", null)
      read_write_type           = lookup(event_selector.value, "read_write_type", null)

      dynamic "data_resource" {
        for_each = lookup(event_selector.value, "data_resource", [])
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  dynamic "insight_selector" {
    for_each = var.insight_selector

    content {
      insight_type = insight_selector.value
    }
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  count = var.cloud_watch_log_group_name != "" ? 1 : 0
  name  = var.cloud_watch_log_group_name
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count          = var.cloud_watch_log_group_name != "" ? 1 : 0
  name           = var.cloud_watch_log_stream
  log_group_name = aws_cloudwatch_log_group.log_group[0].name
}