output "id" {
    description = "ID of cloudtrail"
    value = aws_cloudtrail.default.id
}

output "arn" {
    description = "ARN of cloudtrail"
    value = aws_cloudtrail.default.arn
}

output "home_region" {
    description = "Region in which the trail was created"
    value = aws_cloudtrail.default.home_region
}
