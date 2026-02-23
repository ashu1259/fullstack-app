# ecr.tf

# Flask ECR Repository
resource "aws_ecr_repository" "flask" {
  name                 = "flask-backend"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "flask-backend"
  }
}

# Express ECR Repository
resource "aws_ecr_repository" "express" {
  name                 = "express-frontend"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "express-frontend"
  }
}

# Output ECR URIs
output "flask_ecr_url" {
  value = aws_ecr_repository.flask.repository_url
}

output "express_ecr_url" {
  value = aws_ecr_repository.express.repository_url
}