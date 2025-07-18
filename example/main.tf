
module "naming" {
  source   = "git@github.com:OT-CLOUD-KIT/terraform-aws-naming.git?ref=dev"
  bu       = var.bu
  env      = var.env
  app      = var.app
  tenant   = var.tenant
  resource = var.resource
}

module "standard_tags" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-standard-tagging.git?ref=dev"

  bu      = var.bu
  program = var.program
  app     = var.app
  team    = var.team
  region  = var.region
  env     = var.env
}



module "cloudtrail" {
  source = "git@github.com:OT-CLOUD-KIT/terraform-aws-cloudtrail.git?ref=Feature"

  name                          = var.name
  create_bucket                 = var.create_bucket
  bucket_name                   = var.bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  enable_logging                = var.enable_logging
  enable_log_file_validation    = var.enable_log_file_validation
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  create_log_group              = var.create_log_group
  create_sns_topic              = var.create_sns_topic
  sns_topic_name                = var.sns_topic_name
  kms_key_arn                   = var.kms_key_arn
  is_organization_trail         = var.is_organization_trail
  bu                            = var.bu
  program                       = var.program
  team                          = var.team
  app                           = var.app
  env                           = var.env

  event_selector          = var.event_selector
  advanced_event_selector = var.advanced_event_selector
  insight_selector        = var.insight_selector
  force_destroy           = var.force_destroy
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
