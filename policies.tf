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

# Assume Role Policy
resource "aws_iam_policy" "assume_role" {
  name        = "assume-role-policy"
  description = "Policy allowing users to assume roles"

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