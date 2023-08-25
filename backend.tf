terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "<bucketname>"
    region         = "eu-west-1"
    key            = "<filename>.tfstate"
    dynamodb_table = "<tablename>-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::<aws_account_id>:role/<role_name>"
  }
}
