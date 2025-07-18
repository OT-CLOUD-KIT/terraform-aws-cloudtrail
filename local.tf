locals {
  # Standard tag components
  base_name = "${var.bu}-${var.program}-${var.app}-${var.env}"

  common_tags = {
    "BusinessUnit" = var.bu
    "Program"      = var.program
    "Application"  = var.app
    "Environment"  = var.env
    "Team"         = var.team
     "region"       = var.region
    "ManagedBy"    = "Terraform"
  }

  # Local variables
  bucket_name          = var.create_bucket ? "cloudtrail-bucket-${random_pet.name[0].id}" : var.bucket_name
  cloudwatch_stream    = "${data.aws_caller_identity.current_account.account_id}_${data.aws_region.current.id}"
  s3_key_prefix_path   = "arn:aws:s3:::${local.bucket_name}/${var.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current_account.account_id}/*"


}
