terraform {
  backend "s3" {
    bucket         = var.bucket_s3
    key            = var.key
    region         = var.bucket_s3_region
    dynamodb_table_lock = var.dynamodb_table
    encrypt        = var.encrypt
  }
}


# dev-sa-east-1-pipeline