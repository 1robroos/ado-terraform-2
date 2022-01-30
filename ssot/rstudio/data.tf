data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    region         = "AWS_REGION"
    bucket         = "PROJECT_NAME-bootstrap-state-ENVIRONMENT"
    key            = "terraform.tfstate"
    dynamodb_table = "PROJECT_NAME-bootstrap-state-lock-ENVIRONMENT"
    encrypt        = false
  }
}