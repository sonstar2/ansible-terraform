terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38"
    }
  }

  backend "s3" {
    bucket         = "aws-test-tf-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    # dynamodb_table = "tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

//module "vpc" {
//  source = "./modules/aws/vpc"
  //cidr_blocks = var.cidr_blocks  
  //availability_zones = var.availability_zones  
//}

# resource "aws_instance" "windows_dc_tf" {
#   ami           = var.win_2019_full_ami_id
#   instance_type = "t3.medium"
#   subnet_id = var.subnet_id
#   vpc_security_group_ids = var.security_group_ids
#  // availability_zone = var.availability_zone
#   associate_public_ip_address = true
#   key_name = "aws-test-key"
#   user_data = file("windows_userdata.ps1")
#   tags = {
#     Name :  "dc01tf"
#     os: "windows"
#   }
# }

# resource "aws_instance" "windows_comp01_tf" {
#   ami           = var.win_2019_core_ami_id
#   instance_type = "t3.medium"
#   subnet_id = var.subnet_id
#   vpc_security_group_ids = var.security_group_ids
#   //availability_zone = var.availability_zone
#   associate_public_ip_address = true
#   key_name = "aws-test-key"
#   user_data = file("windows_userdata.ps1")
#   tags = {
#     Name :  "winston-tf"
#     os: "windows"
#   }
# }

# resource "aws_instance" "windows_comp02_tf" {
#   ami           = var.win_2019_core_ami_id
#   instance_type = "t3.medium"
#   subnet_id = var.subnet_id
#   vpc_security_group_ids = var.security_group_ids
#  // availability_zone = var.availability_zone
#   associate_public_ip_address = true
#   key_name = "aws-test-key"
#   user_data = file("windows_userdata.ps1")
#   tags = {
#     Name :  "winthrop-tf"
#     os: "windows"
#   }
# }

# resource "aws_s3_bucket" "s3_bucket_backend" {
#     bucket = "aws-test-tf-bucket"

#     tags = {
#         Name        = "s3_state_bucket"
#         Environment = "Dev"
#     }
# }

resource "aws_s3_bucket_acl" "s3_bucket_backend_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
  bucket     = aws_s3_bucket.s3_bucket_backend.id
  acl        = "private"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket_backend.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_version" {
  bucket = aws_s3_bucket.s3_bucket_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "terraform_folder" {
  bucket = aws_s3_bucket.s3_bucket_backend.id
  key    = "terraform.tfstate"
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_access" {
  bucket                  = aws_s3_bucket.s3_bucket_backend.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
