# Create IAM users
resource "aws_iam_user" "user" {
  name = "user"
}



# Attach assume role policy to users
resource "aws_iam_user_policy_attachment" "user_assume" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.assume_role.arn
}