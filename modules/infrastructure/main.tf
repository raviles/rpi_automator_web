module "buckets" {
  source = "modules/buckets"

  environment = "${var.environment}"
}

module "databases" {
  source = "modules/databases"

  environment = "${var.environment}"
}

module "users" {
  source = "modules/users"
  s3-events-bucket-arn = "${module.buckets.s3-events-bucket-arn}"
  dynamodb-events-table-arn = "${module.databases.dynamodb-events-arn}"

  environment = "${var.environment}"
}

module "iam" {
  source = "modules/iam"
  identity-pool-id = "${module.identity.identity_pool_id}"
  dynamodb-events-table-arn = "${module.databases.dynamodb-events-arn}"

  environment = "${var.environment}"
}

module "identity" {
  source = "modules/identity"
  dynamodb_readonly_role_arn = "${module.iam.dynamodb_readonly_role_arn}"

  environment = "${var.environment}"
}
