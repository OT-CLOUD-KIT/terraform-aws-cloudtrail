# cloudtrail

```
data "aws_caller_identity" "current_account" {}

data "aws_region" "current" {}

locals {
    cloudtrail_name         = format("%s-cloudtrail", data.aws_region.current.name)
    cloudwatch_stream       = format("%s_CloudTrail_%s",data.aws_caller_identity.current_account.account_id,data.aws_region.current.name)
    bucket_name             = "your bucket name"
}

module "cloudtrail" {
  source                        = "./cloudtrail"
  count                         = var.create_cloudtrail == "yes" || var.create_cloudtrail == true ? 1 : 0
  name                          = local.cloudtrail_name
  enable_logging                = true
  enable_log_file_validation    = true
  include_global_service_events = true
  s3_bucket_name                = local.bucket_name
  s3_key_prefix                 = local.cloudtrail_name
  cloud_watch_log_group_name    = var.create_cloudwatch_cloudtrail_role ? local.cloudtrail_name : ""
  cloud_watch_logs_role_arn     = var.create_cloudwatch_cloudtrail_role ? "Enter role arn" : ""
  cloud_watch_log_stream        = local.cloudwatch_stream
  event_selector = [{
    read_write_type           = "All"
    include_management_events = true

    data_resource = [{
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }]
  }]

  insight_selector = var.create_cloudwatch_insight_selector ? { insight_type = "ApiCallRateInsight" } : {}

  depends_on = [
    module.alb_s3_log_bucket,
    data.template_file.alb_s3_log_bucket,
    module.alb
  ]
}
```