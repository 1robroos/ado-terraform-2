terraform {
  backend "s3" {
    region         = "AWS_REGION"
    bucket         = "PROJECT_NAME-APP_NAME-terraform-state-ENVIRONMENT"
    key            = "APP_NAME/terraform.tfstate"
    dynamodb_table = "PROJECT_NAME-APP_NAME-terraform-state-lock-ENVIRONMENT"
    encrypt        = false
  }

#    required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "3.69.0"
    #}
#  }
}
