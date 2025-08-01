#  ////////////////////////////// My SQL Secret Manager ///////////////////////////// 
resource "aws_secretsmanager_secret" "mysql_secret" {
  name = "mysql-credentials-secret"
}

resource "aws_secretsmanager_secret_version" "mysql_secret_version" {
  secret_id = aws_secretsmanager_secret.mysql_secret.id
  secret_string = jsonencode({
    mysql-root-password = var.mySQL_password
    mysql_hostname      = var.mySQL_hostname
    mysql-username      = var.mySQL_username
    mysql-password      = var.mySQL_password
    mysql_port          = "3306"
  })
}
#  ////////////////////////////// Redis Secret Manager ///////////////////////////// 
resource "aws_secretsmanager_secret" "redis_secret" {
  name = "redis-credentials-secret"
}

resource "aws_secretsmanager_secret_version" "redis_secret_version" {
  secret_id = aws_secretsmanager_secret.redis_secret.id
  secret_string = jsonencode({
    redis_hostname = "redis-master"
    redis_port     = "6379"
  })
}

# ///////////////////////////////   Secret Manager Iam policy ////////////////////
resource "aws_iam_policy" "secretsmanager_policy" {
  name        = "secretsmanager-access"
  description = "Allows access to Secrets Manager secrets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ],
        Resource = "*"
      }
    ]
  })
}

