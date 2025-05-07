variable "alb_name" {
  description = "Name / identifier of the application load balancer"
  type        = string

  validation {
    condition     = length(var.alb_name) <= 32
    error_message = "Name string cannot be longer than 32 characters"
  }
}

variable "target_group_name" {
  description = "Name / identifier of the app target group"
  type        = string

  validation {
    condition     = length(var.target_group_name) <= 32
    error_message = "Name string cannot be longer than 32 characters"
  }
}

variable "default_tags" {
  description = "Default resource tags to apply to AWS resources"
  type        = map(string)

  default = {
    project        = ""
    maintainer     = ""
    documentation  = ""
    cost_center    = ""
    IaC_Management = "Terraform"
  }
}

variable "alb_subnets" {
  description = "Subnets in which to run the load balancer"
  type        = list(string)
}

variable "health_check_path" {
  description = "Path on the target to ping to determine app health"
  type        = string

  default = "/"
}

# variable "acm_tls_cert_domain" {
#   description = "Load balancer TLS certificate domain"
#   type        = string
# }

variable "acm_tls_cert_backend_arn" {
  description = "ARN value for backend certificate"
  type = string
}

variable "tls_cipher_policy" {
  description = "TLS Cipher Policy presets for the ALB"
  type        = string

  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "app_port" {
  description = "Application port on the server"
  type        = number
}

variable "ip_address_type" {
  description = "Whether to use IPv4 or IPv6 to reach app servers"
  type        = string

  default = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6"], var.ip_address_type)
    error_message = "IP address type must be either `ipv4` or `ipv6`"
  }
}
