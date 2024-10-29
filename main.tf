provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

# Create IAM users
resource "aws_iam_user" "user" {
  name = "user"
}

# Attach unrestricted role policy to users
resource "aws_iam_user_policy_attachment" "user_assume_unrestricted" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.assume_unrestricted_role.arn
}

# Restricted Role
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

# Unrestricted Role
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

# Attach IP restriction policy to restricted role
resource "aws_iam_role_policy_attachment" "restricted_role_ip" {
  role       = aws_iam_role.restricted_role.name
  policy_arn = aws_iam_policy.ip_restricted.arn
}

# Allow unrestricted role to assume restricted role
resource "aws_iam_role_policy_attachment" "unrestricted_role_assume" {
  role       = aws_iam_role.unrestricted_role.name
  policy_arn = aws_iam_policy.assume_restricted_role.arn
}

# Attach S3 full access policy to restricted role
resource "aws_iam_role_policy_attachment" "restricted_role_s3" {
  role       = aws_iam_role.restricted_role.name
  policy_arn = aws_iam_policy.s3_full_access.arn
} 


# IP Restricted Policy
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

# Assume Restricted Role Policy
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

# Assume Unrestricted Role Policy
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

# S3 Full Access Policy
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