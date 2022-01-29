data "terraform_remote_state" "bootstrap" {
  backend = "s3"

    region         = "AWS_REGION"
    bucket         = "bootstrap-state-ENVIRONMENT"
    key            = "terraform.tfstate"
    dynamodb_table = "bootstrap-state-lock-ENVIRONMENT"
    encrypt        = false
  }