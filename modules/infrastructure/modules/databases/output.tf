output "dynamodb-events-table-name" {
  value = "${aws_dynamodb_table.dynamodb-events-table.name}"
}

output "dynamodb-events-arn" {
  value = "${aws_dynamodb_table.dynamodb-events-table.arn}"
}
