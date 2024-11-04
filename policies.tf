# resource "aws_iam_policy" "ip_restricted" {
#   name        = "ip-restricted-policy"
#   description = "Policy that restricts access to specific IP"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid      = "IPRestriction"
#         Effect   = "Deny"
#         Action   = "*"
#         Resource = "*"
#         Condition = {
#           NotIpAddress = {
#             "aws:SourceIp" = ["${var.allowed_ip}/32"]
#           }
#         }
#       }
#     ]
#   })
# }

resource "aws_" "name" {
  
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
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.restricted_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}