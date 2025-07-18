# Terraform AWS CloudTrail

A Terraform module to provision a secure, compliant, and configurable **AWS CloudTrail** setup. This module supports logging to S3, CloudWatch, SNS notifications, and advanced event selectors for fine-grained data control.


---

## Architecture


---
## Providers

| Name                                              | Version  |
|---------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2   |
| <a name="terraform_module"></a> [Terraform](Terraform\module) | >= 1.12.1|

---

## Usage

```hcl
module "cloudtrail" {
  source = "OT-CLOUD-KIT/terraform-aws-cloudtrail"

  name                          = "ntd-cloudtrail"
  create_bucket                 = true
  bucket_name                   = "" 
  s3_key_prefix                 = "logs"
  enable_logging                = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  include_global_service_events = true
  create_log_group              = true
  create_sns_topic              = true
  sns_topic_name                = "ntd-cloudtrail-topic"
  kms_key_arn                   = "" 
  is_organization_trail         = false
  force_destroy                 = true
  block_public_acls             = true
  block_public_policy           = true
  ignore_public_acls            = true
  restrict_public_buckets       = true

  event_selector = [
    {
      include_management_events = true
      read_write_type           = "All"
      data_resource = [
        {
          type   = "AWS::S3::Object"
          values = ["arn:aws:s3:::example-bucket/"]
        }
      ]
    }
  ]

  advanced_event_selector = []

  insight_selector = ["ApiCallRateInsight"]
}

```
> **Note:**  
> The above example demonstrates how to use the module. All variables, resources, and outputs used here are already defined within this module.


## Resources

| Name                                                                                                                                                                | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [random\_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)                                                              | Resource |
| [aws\_s3\_bucket.log\_collection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                            | Resource |
| [aws\_s3\_bucket\_public\_access\_block.log\_collection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | Resource |
| [aws\_s3\_bucket\_policy.bucket\_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)                              | Resource |
| [aws\_cloudwatch\_log\_group.log\_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                          | Resource |
| [aws\_cloudwatch\_log\_stream.log\_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream)                       | Resource |
| [aws\_iam\_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                         | Resource |
| [aws\_iam\_role\_policy.cloudtrail\_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                            | Resource |
| [aws\_sns\_topic.cloudtrail\_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                            | Resource |
| [aws\_sns\_topic\_policy.cloudtrail\_sns\_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy)                     | Resource |
| [aws\_cloudtrail.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail)                                                   | Resource |


___

## Input

| Name                                                                                                                        | Description                                                                               | Type           | Default                  | Required |
| --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------- | ------------------------ | :------: |
| <a name="input_name"></a> [name](#input_name)                                                                               | Name of the CloudTrail trail                                                              | `string`       | `"cloudtrail"`           |    yes   |
| <a name="input_create_bucket"></a> [create\_bucket](#input_create_bucket)                                                   | Whether to create a new S3 bucket for CloudTrail logs                                     | `bool`         | `true`                   |    yes   |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input_s3_key_prefix)                                                  | S3 prefix for storing CloudTrail logs                                                     | `string`       | `"logs"`                 |    no    |
| <a name="input_enable_logging"></a> [enable\_logging](#input_enable_logging)                                                | Enable logging for the CloudTrail trail                                                   | `bool`         | `true`                   |    no    |
| <a name="input_enable_log_file_validation"></a> [enable\_log\_file\_validation](#input_enable_log_file_validation)          | Enable log file validation for CloudTrail                                                 | `bool`         | `true`                   |    no    |
| <a name="input_create_log_group"></a> [create\_log\_group](#input_create_log_group)                                         | Whether to create a CloudWatch Log Group                                                  | `bool`         | `true`                   |    no    |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input_create_sns_topic)                                         | Whether to create an SNS topic for log delivery notifications                             | `bool`         | `true`                   |    no    |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input_sns_topic_name)                                               | Name of the SNS topic                                                                     | `string`       | `"ntd-cloudtrail-topic"` |    no    |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input_is_multi_region_trail)                         | Whether the trail is multi-region                                                         | `bool`         | `true`                   |    no    |
| <a name="input_include_global_service_events"></a> [include\_global\_service\_events](#input_include_global_service_events) | Include global service events like IAM                                                    | `bool`         | `true`                   |    no    |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input_is_organization_trail)                          | Whether the trail is an AWS Organization trail                                            | `bool`         | `false`                  |    no    |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input_kms_key_arn)                                                        | KMS key ARN for encrypting CloudTrail logs                                                | `string`       | `""`                     |    no    |
| <a name="input_force_destroy"></a> [force\_destroy](#input_force_destroy)                                                   | Whether to force destroy S3 bucket with all objects                                       | `bool`         | `true`                   |    no    |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input_block_public_acls)                                      | Block public ACLs for the S3 bucket                                                       | `bool`         | `true`                   |    no    |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input_block_public_policy)                                | Block public bucket policies                                                              | `bool`         | `true`                   |    no    |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input_ignore_public_acls)                                   | Ignore public ACLs for S3 bucket                                                          | `bool`         | `true`                   |    no    |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input_restrict_public_buckets)                    | Restrict bucket from becoming public                                                      | `bool`         | `true`                   |    no    |
| <a name="input_event_selector"></a> [event\_selector](#input_event_selector)                                                | Event selector for enabling data event logging (conflicts with `advanced_event_selector`) | `list(object)` | `[]`                     |    no    |
| <a name="input_advanced_event_selector"></a> [advanced\_event\_selector](#input_advanced_event_selector)                    | Advanced event selector for enabling data event logging (conflicts with `event_selector`) | `list(object)` | `[]`                     |    no    |
| <a name="input_insight_selector"></a> [insight\_selector](#input_insight_selector)                                          | Type of insights to log (e.g., `ApiCallRateInsight`)                                      | `list(string)` | `[]`                     |    no    |

___

## Output

| Name                                                                                                              | Description                                          |
| ----------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| <a name="output_cloudtrail_arn"></a> [cloudtrail\_arn](#output_cloudtrail_arn)                                    | ARN of the CloudTrail                                |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output_s3_bucket_name)                                   | S3 bucket used for storing CloudTrail logs           |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output_cloudwatch_log_group_name) | CloudWatch Log Group used by CloudTrail (if enabled) |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output_sns_topic_arn)                                      | ARN of the SNS topic                    |

___

## Contributors

- [Piyush Upadhyay](https://github.com/piiiyuushh)
- [Nikita Joshi](https://github.com/jnikita19)

