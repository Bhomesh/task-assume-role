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
  description = "Policy providing full access to S3, including listing all buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "s3:ListAllMyBuckets"
        ]
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
