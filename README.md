AWS Cloudtrail Terraform Module
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Terraform module which creates subnets on AWS.

Types of resources supported:

* [AWS Cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail)


Terraform versions
------------------

Terraform >=v0.14

Usage
------

```hcl
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
  cloud_watch_log_group_name    = local.cloudtrail_name
  cloud_watch_logs_role_arn     = "Enter role arn"
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

}
```

Tags
----
* Default Tags are an easy way to standardize your Terraform Configuration in accordance with AWS’s recommended best practices. We have used the new AWS provider (v3.38.0) feature which allows default_tags to be mentioned in the provider block and will be inherited by dependent Terraform resources and modules

Usage:
```
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner       = "TFProviders"
      Project     = "Test"
      }
    }
}
```
* Tags are assigned to the resource.
* Additional tags can be assigned by appending key-value of tag in subnet resource.

Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the cloudtrail | `string` | `"cloudtrail"` | yes |
| enable_log_file_validation | Specifies whether log file integrity validation is enabled. Creates signed digest for validated contents of logs  | `bool` | `true` | no |
| is_multi_region_trail | Specifies whether the trail is created in the current region or in all regions | `bool` | `false` | no |
| include_global_service_events | Specifies whether the trail is publishing events from global services such as IAM to the log files | `bool` | `false` | no |
| enable_logging |Enable logging for the trail | `bool` | `true` | no |
| cloud_watch_logs_role_arn | Specifies the role for the CloudWatch Logs endpoint to assume to write to a user's log group | `string` | `""` | no |
| cloud_watch_logs_group_arn | Specifies a log group name using an Amazon Resource Name (ARN), that represents the log group to which CloudTrail logs will be delivered | `string` | `""` | no |
| event_selector | Specifies an event selector for enabling data event logging. | `list(object)` | `[]` | no |
| kms_key_arn | The KMS key ARN to use to encrypt the logs delivered by CloudTrail | `string` | `""` | no |
| is_organization_trail | The trail is an AWS Organizations trail | `bool` | `false` | no |
| sns_topic_name | Specifies the name of the Amazon SNS topic defined for notification of log file delivery | `string` | `null` | no |
| tags | Tags for Cloudtrail | `map` | `{Owner: 'test'}` | no |
| insight_selector | Type of insights to log on a trail. The valid value is ApiCallRateInsight | `map` | `{insight_type: 'ApiCallRateInsight'}` | no |
| cloud_watch_log_group_name | Name of log group. If this is provided, cloudtrail will be configured with cloudwatch logging. | `string` | `""` | no |

Output
------
| Name | Description |
|------|-------------|
| id | Name of the trail |
| arn | ARN of the trail |
| home_region | Region in which the trail was created |
### Contributors

[![Prakash Jha][prakash_avatar]][prakash_homepage]<br/>[Prakash Jha][prakash_homepage] 

  [prakash_homepage]: https://github.com/prakashjha-ot
  [prakash_avatar]: https://img.cloudposse.com/75x75/https://github.com/prakashjha-ot.png
