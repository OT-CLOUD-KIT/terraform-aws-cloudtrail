locals {
    bucket_name = var.create_bucket ? "${var.name}-${random_pet.name[0].id}" : var.s3_bucket_name
    cloudwatch_stream = format("%s_CloudTrail_%s",data.aws_caller_identity.current_account.account_id,data.aws_region.current.name)
    s3_key_prefix_path = var.s3_key_prefix == null ? "arn:aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_caller_identity.current_account.account_id}/*" : "arn:aws:s3:::${local.bucket_name}/${var.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current_account.account_id}/*"
}
