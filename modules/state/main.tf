resource "aws_s3_bucket" "state-file-bucket" {
  bucket = "rpi-auto-${var.environment}-state-file"

  versioning {
    enabled = true
  }

  tags {
    environment = "${var.environment}"
  }
}

resource "aws_dynamodb_table" "state-file-locking-table" {
  name           = "${var.environment}-state-file-locking"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    environment = "${var.environment}"
  }
}
