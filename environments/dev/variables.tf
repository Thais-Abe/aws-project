variable "bucket_s3" {
  type = string
  description = "Bucket usado para armazenamento do S3"
}

variable "key" {
  type = string
  description = "valor chave"
}

variable "bucket_s3_region" {
    type = string
    description = "região do bucket s3"
}

variable "dynamodb_table_lock" {
  type = string
}

variable "encrypt" {
  type = bool
  description = "criptografia do tfstate"
}