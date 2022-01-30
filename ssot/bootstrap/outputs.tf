output "s3_bucket_url" {
  value = aws_s3_bucket.bootstrapbucket.website_endpoint
}
