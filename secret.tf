resource "random_password" "mysql" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "ec2-instance/mysql_root_user_password"
  description             = "MYSQL Root user password"
  recovery_window_in_days = "0"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  depends_on = [random_password.mysql]
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = random_password.mysql.result

  lifecycle {
    ignore_changes  = [secret_string]
    prevent_destroy = true
  }
}
