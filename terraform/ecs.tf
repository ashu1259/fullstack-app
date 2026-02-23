# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "fullstack-cluster"
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Effect    = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Flask Task Definition
resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "flask-container"
    image     = aws_ecr_repository.flask.repository_url
    essential = true
    portMappings = [{ containerPort = 5000, hostPort = 5000 }]
  }])
}

# Express Task Definition
resource "aws_ecs_task_definition" "express_task" {
  family                   = "express-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "express-container"
    image     = aws_ecr_repository.express.repository_url
    essential = true
    portMappings = [{ containerPort = 3000, hostPort = 3000 }]
  }])
}

# ECS Services
resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_tg.arn
    container_name   = "flask-container"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.http_listener]
}

resource "aws_ecs_service" "express_service" {
  name            = "express-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.express_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_tg.arn
    container_name   = "express-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http_listener]
}