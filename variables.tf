variable "allowed_ip" {
  description = "IP address allowed to access the restricted role"
  type        = string
  default     = "13.233.154.138"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
} 