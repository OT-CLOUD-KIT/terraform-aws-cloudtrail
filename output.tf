output "id" {
    description = "ID of cloudtrail"
    value = aws_cloudtrail.cloudtrail.id
}

output "arn" {
    description = "ARN of cloudtrail"
    value = aws_cloudtrail.cloudtrail.arn
}

output "home_region" {
    description = "Region in which the trail was created"
    value = aws_cloudtrail.cloudtrail.home_region
}
