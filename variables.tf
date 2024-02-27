variable "project_meta" {
  description = "Metadata relating to the project for which the VPC is being created"
  type        = map(string)

  default = {
    name       = ""
    short_name = ""
    version    = ""
    url        = ""
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

variable "acm_tls_cert_domain" {
  description = "Load balancer TLS certificate domain"
  type        = string
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
