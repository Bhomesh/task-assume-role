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