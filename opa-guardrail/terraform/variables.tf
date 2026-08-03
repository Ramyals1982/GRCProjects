# AWS Region where resources will be provisioned
variable "aws_region" {
  type        = string
  description = "Target AWS Region for infrastructure deployment."
  default     = "us-east-1"
}

# Environment designation for resource tagging
variable "environment" {
  type        = string
  description = "Target execution environment (e.g., Dev, Staging, Production)."
  default     = "Dev"
}

# Mandatory CostCenter code for enterprise billing compliance
variable "cost_center" {
  type        = string
  description = "Mandatory billing code assigned by Finance."
  default     = "FIN-99201"
}