resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.name
  enable_logging                = var.enable_logging
  s3_bucket_name                = var.create_bucket ? aws_s3_bucket.log_collection[0].id : local.bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  enable_log_file_validation    = var.enable_log_file_validation
  sns_topic_name                = var.sns_topic_name
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  cloud_watch_logs_role_arn     = var.create_log_group ? aws_iam_role.role[0].arn : ""
  cloud_watch_logs_group_arn    = var.create_log_group ? "${aws_cloudwatch_log_group.log_group[0].arn}:*" : ""
  tags                          = merge(var.tags,{Name = var.name})
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

  dynamic "advanced_event_selector" {
    for_each = var.advanced_event_selector
    content {
    name = lookup(advanced_event_selector.value,"name")
    
    dynamic "field_selector" {
      for_each = lookup(advanced_event_selector.value,"field_selector")

      content {
        field   = field_selector.value.field
        equals = try(field_selector.value.equals,null)
        ends_with = try(field_selector.value.ends_with,null)
        not_ends_with = try(field_selector.value.not_ends_with,null)
        not_equals = try(field_selector.value.not_equals,null)
        not_starts_with = try(field_selector.value.not_starts_with,null)
        starts_with = lookup(field_selector.value,"starts_with",null)
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
  depends_on = [
    aws_s3_bucket.log_collection,
    aws_cloudwatch_log_group.log_group,
    aws_s3_bucket_policy.bucket_policy
  ]
}

resource "aws_cloudwatch_log_group" "log_group" {
  count = var.create_log_group ? 1 : 0
  name  = "${var.name}-cloudtrail-log-group"
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count          = var.create_log_group ? 1 : 0
  name           = format("%s_CloudTrail_%s",data.aws_caller_identity.current_account.account_id,data.aws_region.current.name)
  log_group_name = aws_cloudwatch_log_group.log_group[0].name
}

resource "random_pet" "name" {
  count = var.create_bucket ? 1 : 0
  length = 2
  separator = "-"
}

resource "aws_s3_bucket" "log_collection" {
  count = var.create_bucket ? 1 : 0
  bucket = local.bucket_name
  tags = merge(var.tags,{Name = local.bucket_name})
}

resource "aws_s3_bucket_public_access_block" "log_collection" {
  count = var.create_bucket ? 1 : 0
  bucket                  = aws_s3_bucket.log_collection[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.create_bucket ? aws_s3_bucket.log_collection[0].id : local.bucket_name
  policy = <<POLICY
  {
    "Version" : "2012-10-17",
    "Id" : "AWSConsole-AccessLogs-Policy-1618393403791",
    "Statement" : [
      {
        "Sid": "AWSCloudTrailAclCheck20150319",
        "Effect": "Allow",
        "Principal": {"Service": "cloudtrail.amazonaws.com"},
        "Action": "s3:GetBucketAcl",
        "Resource": "arn:aws:s3:::${local.bucket_name}"
    },
    {
        "Sid": "AWSCloudTrailWrite20150319",
        "Effect": "Allow",
        "Principal": {"Service": "cloudtrail.amazonaws.com"},
        "Action": "s3:PutObject",
        "Resource": "${local.s3_key_prefix_path}",
        "Condition": {"StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control",
          "AWS:SourceArn": "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current_account.account_id}:trail/${var.name}"
          }}
    }
    ]
  }
POLICY

}

resource "aws_iam_role" "role" {
  count = var.create_log_group ? 1 : 0
  name               = "${var.name}-cloudtrail-cloudwatch-log-group-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "cloudtrail_inline_policy"
    
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
  
        "Sid": "AWSCloudTrailCreateLogStream2014110",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream"
        ],
        "Resource": [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current_account.account_id}:log-group:${var.name}-cloudtrail-log-group:log-stream:${local.cloudwatch_stream}*"
        ]
  
      },
      {
        "Sid": "AWSCloudTrailPutLogEvents20141101",
        "Effect": "Allow",
        "Action": [
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current_account.account_id}:log-group:${var.name}-cloudtrail-log-group:log-stream:${local.cloudwatch_stream}*"
        ]
      }
    ]
  })
  }
}
