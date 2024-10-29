# Create IAM users
resource "aws_iam_user" "restricted_user" {
  name = "restricted-user"
}

resource "aws_iam_user" "unrestricted_user" {
  name = "unrestricted-user"
}

# Attach assume role policy to users
resource "aws_iam_user_policy_attachment" "restricted_user_assume" {
  user       = aws_iam_user.restricted_user.name
  policy_arn = aws_iam_policy.assume_role.arn
}

resource "aws_iam_user_policy_attachment" "unrestricted_user_assume" {
  user       = aws_iam_user.unrestricted_user.name
  policy_arn = aws_iam_policy.assume_role.arn
} 