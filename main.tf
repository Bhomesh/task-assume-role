provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

variable "allowed_ip" {
  description = "IP address allowed to access the restricted role"
  type        = string
  default     = "15.207.116.54"  # Replace with your actual IP address
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

resource "aws_iam_user" "user" {
  name = "user"
}

resource "aws_iam_user_policy_attachment" "user_assume_unrestricted" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.assume_unrestricted_role.arn
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-unique-bucket-name"  # Replace with a unique bucket name
  acl    = "private"
}

