resource "aws_secretsmanager_secret" "metadata" {
  name = "admin-password-${terraform.workspace}"
}

resource "aws_secretsmanager_secret_version" "details" {
  secret_id     = "${aws_secretsmanager_secret.metadata.id}"
  secret_string = "${random_string.value.result}"
}

resource "random_string" "value" {
  length = 25
  special = true
  override_special = "-*%$#£&"
}
