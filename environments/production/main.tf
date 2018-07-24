provider "aws" {
  region = "${var.region}"
}

module "production-state" {
  source = "../../modules/state"

  environment = "${var.environment}"
}

terraform {
  backend "s3" {
    bucket  = "rpi-auto-production-state-file"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "production-infrastructure" {
  source = "../../modules/infrastructure"

  environment = "${var.environment}"
}

module "production-web" {
  source = "../../modules/web-deploy"

  environment = "${var.environment}"
}

output "dynamodb-events-table" {
  value = "${module.production-infrastructure.dynamodb-events-table-name}"
}
