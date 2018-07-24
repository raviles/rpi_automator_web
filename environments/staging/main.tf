provider "aws" {
  region = "${var.region}"
}

module "staging-state" {
  source = "../../modules/state"

  environment = "${var.environment}"
}

terraform {
  backend "s3" {
    bucket  = "rpi-auto-staging-state-file"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "staging-infrastructure" {
  source = "../../modules/infrastructure"

  environment = "${var.environment}"
}

module "staging-web" {
  source = "../../modules/web-deploy"

  environment = "${var.environment}"
}

output "dynamodb-events-table" {
  value = "${module.staging-infrastructure.dynamodb-events-table-name}"
}
