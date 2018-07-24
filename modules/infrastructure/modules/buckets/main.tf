resource "aws_s3_bucket" "events-static-web" {
  bucket = "events-web-${var.environment}"
  acl = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }

  tags {
    environment = "${var.environment}"
  }

}