output "dynamodb_readonly_role_arn" {
  value = "${aws_iam_role.dynamodb_readonly_role.arn}"
}
