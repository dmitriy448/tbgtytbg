terraform {
  backend "s3" {
    bucket         = "s3-backend-postgre-exchangeapp"
    dynamodb_table = "backend-state-locking"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}



module "db_postgre" {
  source               = "./rdsmodule"
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name
  db_username          = "aws_ssm_parameter.db_username_parameter.value"
  parameter_group_name = "default.postgres"
  data                 = var.data
  cidr_blocks          = var.cidr_blocks
  maintenance          = var.maintenance
  vpc_id               = var.vpc_id
  region               = var.region
  env_identifier       = var.env_identifier
  backup               = var.backup
  backup_retention     = var.backup_retention
  subnet_id1           = var.subnet_id1
  subnet_id2           = var.subnet_id2      

}


#S3 backend

resource "aws_s3_bucket" "s3_backend" {
  bucket = "s3-backend-postgre-exchangeapp"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_dynamodb_table" "backend" {
  name         = "backend-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}