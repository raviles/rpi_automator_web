resource "aws_dynamodb_table" "dynamodb-events-table" {
  name           = "${var.environment}-events"
  hash_key       = "module_type"
  range_key      = "epoch"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "module_type"
    type = "S"
  }

  attribute {
    name = "epoch"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled = false
  }

  tags {
    environment = "${var.environment}"
  }
}