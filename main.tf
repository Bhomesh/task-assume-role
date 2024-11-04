provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "user" {
  name = "user"
}

resource "aws_iam_user_policy_attachment" "user_assume_unrestricted" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.assume_unrestricted_role.arn
}


