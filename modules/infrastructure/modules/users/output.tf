output "rpi_automator_user_access_key_id" {
  value = "${aws_iam_access_key.rpi_automator_user.id}"
}

output "rpi_automator_user_access_secret" {
  value = "${aws_iam_access_key.rpi_automator_user.secret}"
}


