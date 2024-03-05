output "load_balancer_arn" {
  description = "ARN of the application load balancer"
  value       = aws_lb.public.arn
}

output "load_balancer_arn_suffix" {
  description = "ARN of the application load balancer"
  value       = aws_lb.public.arn_suffix
}

output "load_balancer_dns" {
  description = "ARN of the application load balancer"
  value       = aws_lb.public.dns_name
}

output "load_balancer_dns_zone" {
  description = "ARN of the application load balancer"
  value       = aws_lb.public.zone_id
}

output "target_group_arn" {
  description = "ARN of the load balancer target group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_arn_suffix" {
  description = "ARN of the load balancer target group"
  value       = aws_lb_target_group.main.arn_suffix
}

output "load_balancer_public_security_group" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.public.id
}

output "load_balancer_app_security_group" {
  description = "ID of security group to connect the ALB and the app"
  value       = aws_security_group.lb-app.id
}
