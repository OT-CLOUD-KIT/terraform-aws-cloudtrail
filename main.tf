
# Random pet for S3 bucket name uniqueness
resource "random_pet" "name" {
  count     = var.create_bucket ? 1 : 0
  length    = 2
  separator = "-"
}


# -----------------------------
# S3 Bucket (optional)
# -----------------------------
resource "aws_s3_bucket" "log_collection" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(local.common_tags, { Name = local.bucket_name })
}

resource "aws_s3_bucket_public_access_block" "log_collection" {
  count                   = var.create_bucket ? 1 : 0
  bucket                  = aws_s3_bucket.log_collection[0].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.create_bucket ? 1 : 0
  bucket = local.bucket_name

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
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
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control",
            "AWS:SourceArn": "arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current_account.account_id}:trail/${var.name}"
          }
        }
      }
    ]
  }
  POLICY
}

# -----------------------------
# CloudWatch Logs (optional)
# -----------------------------
resource "aws_cloudwatch_log_group" "log_group" {
  count              = var.create_log_group ? 1 : 0
  name              = "${local.base_name}-cloudtrail-log-group"
  retention_in_days  = 7
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  count          = var.create_log_group ? 1 : 0
  name           = local.cloudwatch_stream
  log_group_name = aws_cloudwatch_log_group.log_group[0].name
}



resource "aws_iam_role" "role" {
  count = var.create_log_group ? 1 : 0
  name  = "${local.base_name}-cloudtrail-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "cloudtrail.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  count = var.create_log_group ? 1 : 0

  name = "cloudtrail-cloudwatch-policy"
  role = aws_iam_role.role[0].name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowLogGroupAccess",
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy"
        ],
        Resource = [
          "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current_account.account_id}:log-group:${var.name}-cloudtrail-log-group:*",
          "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current_account.account_id}:log-group:${var.name}-cloudtrail-log-group"
        ]
      }
    ]
  })
}

# -----------------------------
# SNS Topic (optional)
# -----------------------------
resource "aws_sns_topic" "cloudtrail_sns" {
  count = var.create_sns_topic ? 1 : 0
  name  = "${local.base_name}-cloudtrail-sns"
  tags  = merge(local.common_tags, { Name = "${local.base_name}-cloudtrail-sns" })
}

resource "aws_sns_topic_policy" "cloudtrail_sns_policy" {
  count  = var.create_sns_topic ? 1 : 0
  arn    = aws_sns_topic.cloudtrail_sns[0].arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "cloudtrail.amazonaws.com" },
      Action    = "SNS:Publish",
      Resource  = aws_sns_topic.cloudtrail_sns[0].arn
    }]
  })
}

# -----------------------------
# CloudTrail
# -----------------------------
resource "aws_cloudtrail" "default" {
  name = "${local.base_name}-cloudtrail"
  enable_logging                = var.enable_logging
  s3_bucket_name                = local.bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  enable_log_file_validation    = var.enable_log_file_validation
  sns_topic_name                = var.create_sns_topic ? aws_sns_topic.cloudtrail_sns[0].name : var.sns_topic_name
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  cloud_watch_logs_role_arn     = var.create_log_group ? aws_iam_role.role[0].arn : ""
  cloud_watch_logs_group_arn    = var.create_log_group ? "${aws_cloudwatch_log_group.log_group[0].arn}:*" : ""
  kms_key_id                    = var.kms_key_arn
  is_organization_trail         = var.is_organization_trail
  tags = merge(local.common_tags, { Name = "${local.base_name}-cloudtrail" })

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
      name = lookup(advanced_event_selector.value, "name")

      dynamic "field_selector" {
        for_each = lookup(advanced_event_selector.value, "field_selector")
        content {
          field            = field_selector.value.field
          equals           = try(field_selector.value.equals, null)
          ends_with        = try(field_selector.value.ends_with, null)
          not_ends_with    = try(field_selector.value.not_ends_with, null)
          not_equals       = try(field_selector.value.not_equals, null)
          not_starts_with  = try(field_selector.value.not_starts_with, null)
          starts_with      = lookup(field_selector.value, "starts_with", null)
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
    aws_s3_bucket_policy.bucket_policy,
    aws_cloudwatch_log_group.log_group
  ]
}

