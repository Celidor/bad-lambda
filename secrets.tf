resource "aws_secretsmanager_secret" "metadata" {
  name = "admin-password-${random_string.unique.result}-${terraform.workspace}"
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

resource "random_string" "unique" {
  length = 5
  special = false
}