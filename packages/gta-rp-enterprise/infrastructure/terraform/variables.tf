variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "gta-rp-enterprise"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "fivem_db"
  sensitive   = true
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "fivem_user"
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_instance_count" {
  description = "Number of database instances"
  type        = number
  default     = 1
  validation {
    condition     = var.db_instance_count > 0 && var.db_instance_count <= 5
    error_message = "Instance count must be between 1 and 5."
  }
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "ecs_task_cpu" {
  description = "ECS task CPU"
  type        = string
  default     = "512"
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  type        = string
  default     = "1024"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
