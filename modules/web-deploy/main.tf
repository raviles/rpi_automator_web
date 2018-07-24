resource "aws_s3_bucket_object" "index" {
  bucket = "events-web-${var.environment}"
  key    = "index.html"
  source = "../../src/web/index.html"
  etag   = "${md5(file("../../src/web/index.html"))}"
}

resource "aws_s3_bucket_object" "appjs" {
  bucket = "events-web-${var.environment}"
  key    = "static/app.js"
  source = "../../src/web/static/app.js"
  etag   = "${md5(file("../../src/web/static/app.js"))}"
}

resource "aws_s3_bucket_object" "awssdk" {
  bucket = "events-web-${var.environment}"
  key    = "static/aws-sdk-2.344.0.min.js"
  source = "../../src/web/static/aws-sdk-2.344.0.min.js"
  etag   = "${md5(file("../../src/web/static/aws-sdk-2.344.0.min.js"))}"
}

resource "aws_s3_bucket_object" "envjs" {
  bucket = "events-web-${var.environment}"
  key    = "static/env.js"
  source = "../../src/web/static/env.js"
  etag   = "${md5(file("../../src/web/static/env.js"))}"
}
