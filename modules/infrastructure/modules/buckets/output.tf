output "s3-events-bucket" {
  value = "${aws_s3_bucket.events-static-web.bucket}"
}

output "s3-events-bucket-arn" {
  value = "${aws_s3_bucket.events-static-web.arn}"
}
