variable "allowed_ip" {
  description = "IP address allowed to access the restricted role"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
} 