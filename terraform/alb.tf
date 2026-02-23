# Application Load Balancer
resource "aws_lb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id
}

# Target Groups
resource "aws_lb_target_group" "flask_tg" {
  name     = "flask-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "express_tg" {
  name     = "express-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

# Listener Rules
resource "aws_lb_listener_rule" "flask_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }
  condition {
    path_pattern { values = ["/api*"] }
  }
}

resource "aws_lb_listener_rule" "express_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.express_tg.arn
  }
  condition {
    path_pattern { values = ["/*"] }
  }
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}