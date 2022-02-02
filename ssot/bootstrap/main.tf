# module "vpc" {
#   source             = "terraform-aws-modules/vpc/aws"
#   version            = "~>2.0"
#   name               = local.prefix
#   cidr               = local.vpc_cidr
#   private_subnets    = local.private_subnets
#   public_subnets     = local.public_subnets
#   enable_nat_gateway = false
#   enable_vpn_gateway = false

#   azs = local.availability_zones

#   tags = local.tags
# }


resource "aws_s3_bucket" "bootstrapbucket" {
  acl = "public-read"
  bucket = "bootstrapbucket-${var.environment}"

  website {
    index_document = "index.html"
  }

  tags = local.tags
}

resource "aws_s3_bucket_object" "bootstrapbucketObject" {
  bucket       = aws_s3_bucket.bootstrapbucket.id
  key          = "index.html"
  acl          = "public-read"
  content      = "<h1>Welcome to the bootstrap ${var.environment} environment</h1>"
  content_type = "text/html"

  tags = local.tags
}

resource "aws_security_group" "sg-bootstrapbucket" {
  name        = format("%s-zomaar-bootstrapbucket-sg", var.environment)
  description = "Security group for ${var.environment} app"
  vpc_id      = "vpc-06bceb9729a541195"
  tags = {
    Name = format("%s-bootstrap-sg", var.environment)
    Terrafom = true
    Stage = var.environment
  }
}

resource "aws_security_group" "extra_resources_bootstrap_SG" {
  name        = format("%s-extra_resources_bootstrap_SG-sg", var.environment)
  description = "Security group _2_for ${var.environment} app"
  vpc_id      = "vpc-06bceb9729a541195"
  tags = {
    Name                  = format("%s-extra_resources_bootstrap_SG-sg", var.environment)
    Terrafom              = true
    Stage                 = var.environment
  }
}