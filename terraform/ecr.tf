resource "aws_ecr_repository" "flask" {
  name                 = "flask-backend"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "express" {
  name                 = "express-frontend"
  image_tag_mutability = "MUTABLE"
}

output "flask_ecr_url" {
  value = aws_ecr_repository.flask.repository_url
}

output "express_ecr_url" {
  value = aws_ecr_repository.express.repository_url
}