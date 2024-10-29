resource "aws_s3_bucket" "example_bucket" {
  bucket = "test"  # Replace with a unique bucket name
  acl    = "private"
} 