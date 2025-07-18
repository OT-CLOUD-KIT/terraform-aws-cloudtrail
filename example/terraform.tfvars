name                          = "ntd-cloudtrail"
create_bucket                 = true
s3_key_prefix                 = "logs"
enable_logging                = true
enable_log_file_validation    = true
create_log_group              = true
create_sns_topic              = true
sns_topic_name                = "ntd-cloudtrail-topic"
is_multi_region_trail         = true
include_global_service_events = true
is_organization_trail         = false
kms_key_arn                   = "" # leave blank if not using encryption
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


################# Naming Convension #####################

random_alphanumeric_len = 4

bu       = "ot"
app      = "bp"
env      = "d"
resource = "cloud-trail"
tenant   = ""

special = false
upper   = false
number  = true

gen_no_of_names = 1

team    = "infra"
program = "ot"

