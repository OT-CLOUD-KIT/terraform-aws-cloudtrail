AWS Cloudtrail Terraform Module
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Terraform module which creates subnets on AWS.

Types of resources supported:

* [AWS Cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail)
* [Cloudwatch Log group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)
* [Cloudwatch Log stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream)
* [AWS IAM role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)
* [AWS S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
* [AWS S3 bucket policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)


Terraform versions
------------------

Terraform >=v0.15

Usage
------

```hcl
provider "aws" {
  region = "us-east-1"
}

module "cloudtrail" {
  source                        = "OT-CLOUD-KIT/cloudtrail/aws"
  name                          = "testing"
  enable_logging                = true
  enable_log_file_validation    = true
  include_global_service_events = true
  create_bucket                 = false
  create_log_group              = false
  s3_bucket_name                = "testingwaransible"
  s3_key_prefix                 = "newprefix"

  # event_selector = [{
  #   read_write_type           = "All"
  #   include_management_events = true

  #   data_resource = [{
  #     type   = "AWS::S3::Object"
  #     values = ["arn:aws:s3:::"]
  #   }]
  # }]

  advanced_event_selector = [
    {
      field_selector = [
        {
          equals = [
            "Management"
          ]
          field           = "eventCategory"
          
        }
      ]
      name = "event1"
    },
    {
      field_selector = [
        {
          equals = [
            "Data"
          ]
          field           = "eventCategory"
          
        },
        {
            field = "resources.type",
        equals = [
          "AWS::S3::Object"
        ],
        }
      ]
      name = "event2"
    }
  ]
  insight_selector = { insight_type = "ApiCallRateInsight" }

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

Note
----

1. You can either use event_selector or advanced_event_selector.
2. If you use s3_bucket_name, create_bucket must be false, and this module will automatically add bucket policy to allow cloudtrail logs into the bucket, and will override any policy already present


Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the cloudtrail | `string` | `"cloudtrail"` | yes |
| enable_log_file_validation | Specifies whether log file integrity validation is enabled. Creates signed digest for validated contents of logs  | `bool` | `true` | no |
| is_multi_region_trail | Specifies whether the trail is created in the current region or in all regions | `bool` | `false` | no |
| include_global_service_events | Specifies whether the trail is publishing events from global services such as IAM to the log files | `bool` | `false` | no |
| enable_logging |Enable logging for the trail | `bool` | `true` | no |
| create_bucket | If true, it will create a new bucket with policy. If false, you will have to pass a bucket name | `bool` | `true` | yes |
| s3_bucket_name | Provide S3 bucket name for CloudTrail logs if you specify create_bucket=false | `string` | `""` | no |
| s3_key_prefix | S3 bucket prefix for CloudTrail logs | `string` | `null` | no |
| event_selector | Specifies an event selector for enabling data event logging. Conflicts with advanced_event_selector| `list(object)` | `[]` | no |
| kms_key_arn | The KMS key ARN to use to encrypt the logs delivered by CloudTrail | `string` | `""` | no |
| is_organization_trail | The trail is an AWS Organizations trail | `bool` | `false` | no |
| sns_topic_name | Specifies the name of the Amazon SNS topic defined for notification of log file delivery | `string` | `null` | no |
| tags | Tags for Cloudtrail | `map` | `` | no |
| insight_selector | Type of insights to log on a trail. The valid value is ApiCallRateInsight | `map` | `{}` | no |
| create_log_group | If this is provided, cloudtrail will be configured with cloudwatch logging. | `bool` | `true` | no |
| advanced_event_selector | specifies an advanced event selector for enabling data event logging. Conflicts with event_selector | `list(object)` | `[]` | no |

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
