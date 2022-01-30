terraform {
  backend "s3" {
    region         = "AWS_REGION"
    bucket         = "PROJECT_NAME-APP_NAME-state-ENVIRONMENT"
    key            = "APP_NAME/terraform.tfstate"
    dynamodb_table = "PROJECT_NAME-APP_NAME-state-lock-ENVIRONMENT"
    encrypt        = false
  }
}
