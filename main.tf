data "aws_acm_certificate" "wildcard" {
  domain      = var.acm_tls_cert_domain
  statuses    = ["ISSUED"]
  most_recent = true

  key_types = ["RSA_2048", "RSA_3072", "RSA_4096", "EC_prime256v1", "EC_secp384r1", "EC_secp521r1"]
}

resource "aws_security_group" "public" {
  name_prefix = "alb_public_access"
  description = "Public access for load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTPS connections from everywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Allow HTTP connections to allow redirection to HTTPS"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "lb-app" {
  name_prefix = "alb_app_access"
  description = "App access from self"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow app port connections from self"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_lb" "public" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.public.id,
    aws_security_group.lb-app.id
  ]
  subnets = var.alb_subnets

  enable_deletion_protection = false
  ip_address_type            = "dualstack"

  idle_timeout = 1800
}

resource "aws_lb_target_group" "main" {
  name            = var.target_group_name
  port            = var.app_port
  protocol        = "HTTP"
  vpc_id          = var.vpc_id
  target_type     = "ip"
  ip_address_type = var.ip_address_type

  health_check {
    enabled = true
    path    = var.health_check_path
    port    = "traffic-port"

    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 6
  }
}

resource "aws_lb_listener" "secure" {
  load_balancer_arn = aws_lb.public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.tls_cipher_policy
  certificate_arn   = data.aws_acm_certificate.wildcard.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "insecure" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

