resource "aws_lb" "main" {
  name               = "ecs-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}
resource "aws_lb_target_group" "flask_tg" {
  name     = "flask-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "ip"
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }
}
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "ecs/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}