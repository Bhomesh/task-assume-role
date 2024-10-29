output "restricted_role_arn" {
  value       = aws_iam_role.restricted_role.arn
  description = "ARN of the restricted IAM role"
}

output "unrestricted_role_arn" {
  value       = aws_iam_role.unrestricted_role.arn
  description = "ARN of the unrestricted IAM role"
}

output "restricted_user_name" {
  value       = aws_iam_user.restricted_user.name
  description = "Name of the restricted IAM user"
}

output "unrestricted_user_name" {
  value       = aws_iam_user.unrestricted_user.name
  description = "Name of the unrestricted IAM user"
} 