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

resource "aws_iam_policy" "ip_restricted" {
  name        = "ip-restricted-policy"
  description = "Policy that restricts access to specific IP"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "IPRestriction"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          NotIpAddress = {
            "aws:SourceIp" = ["${var.allowed_ip}/32"]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_full_access" {
  name        = "s3-full-access-policy"
  description = "Policy providing full access to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "assume_restricted_role" {
  name        = "assume-restricted-role-policy"
  description = "Policy allowing unrestricted role to assume restricted role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = [
          aws_iam_role.restricted_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "assume_unrestricted_role" {
  name        = "assume-unrestricted-role-policy"
  description = "Policy allowing user to assume unrestricted role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Resource = [
          aws_iam_role.unrestricted_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "restricted_role" {
  name = "restricted-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.unrestricted_role.arn
        }
      }
    ]
  })
}

resource "aws_iam_role" "unrestricted_role" {
  name = "unrestricted-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "restricted_role_ip" {
  role       = aws_iam_role.restricted_role.name
  policy_arn = aws_iam_policy.ip_restricted.arn
}

resource "aws_iam_role_policy_attachment" "restricted_role_s3" {
  role       = aws_iam_role.restricted_role.name
  policy_arn = aws_iam_policy.s3_full_access.arn
}

resource "aws_iam_role_policy_attachment" "unrestricted_role_assume" {
  role       = aws_iam_role.unrestricted_role.name
  policy_arn = aws_iam_policy.assume_restricted_role.arn
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
} 