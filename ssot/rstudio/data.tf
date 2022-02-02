data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    region         = "AWS_REGION"
    bucket         = "PROJECT_NAME-bootstrap-terraform-state-ENVIRONMENT"
    key            = "bootstrap/terraform.tfstate"
    dynamodb_table = "PROJECT_NAME-bootstrap-terraform-state-lock-ENVIRONMENT"
    encrypt        = false
  }
}