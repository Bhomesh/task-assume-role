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