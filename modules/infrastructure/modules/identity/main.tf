resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "${var.environment} identity pool"
  allow_unauthenticated_identities = true
}

resource "aws_cognito_identity_pool_roles_attachment" "events-identity-web-unauthenticated" {
  identity_pool_id = "${aws_cognito_identity_pool.identity_pool.id}"

  roles {
    "unauthenticated" = "${var.dynamodb_readonly_role_arn}"
  }
}
