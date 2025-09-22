locals {
  # Standard tag components
  base_name = "${var.env}- ${n}"

  common_tags = {
    env =  var.env
    owner = var.owner
    app = var.app
  }

  # Local variables
  bucket_name          = var.create_bucket ? "cloudtrail-bucket-${random_pet.name[0].id}" : var.bucket_name
  cloudwatch_stream    = "${data.aws_caller_identity.current_account.account_id}_${data.aws_region.current.id}"
  s3_key_prefix_path   = "arn:aws:s3:::${local.bucket_name}/${var.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current_account.account_id}/*"


}
