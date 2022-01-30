resource "aws_s3_bucket" "rstudio" {
  bucket = "rstudiobucket-${var.environment}"
  acl = "public-read"

  website {
    index_document = "index.html"
  }

  tags = local.tags
}

resource "aws_s3_bucket_object" "rstudio" {
  bucket       = aws_s3_bucket.rstudio.id
  key          = "index.html"
  acl          = "public-read"
  content      = "<h2>Welcome to the ${var.environment} rstudio environment, this is bootstrap bucket ${data.terraform_remote_state.bootstrap.outputs.s3_bucket_url}</h2> bootstrapbucket-dev.s3-website-us-east-1.amazonaws.com"
  content_type = "text/html"

  tags = local.tags
}

resource "aws_security_group" "zomaar_rstudio_SG" {
  name        = format("%s-zomaar_rstudio_SG-sg", var.environment)
  description = "Security group for ${var.environment} app"
  vpc_id      = "vpc-06bceb9729a541195"
  tags = {
    Name                  = format("%s-zomaar_rstudio_SG-sg", var.environment)
    Terrafom              = true
    Stage                 = var.environment
    bootstrapoutputbucket = data.terraform_remote_state.bootstrap.outputs.s3_bucket_url
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "ec2_instance_rstudio_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "templates-single-instance_rstudio_${var.environment}"

  ami           = data.aws_ami.ubuntu.id
  instance_type = local.ec2_type
  monitoring    = true
  #vpc_security_group_ids = [aws_security_group.zomaar_rstudio_SG.id]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

