terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

# Non-Compliant Bucket: Public access allowed, missing required CostCenter tag
resource "aws_s3_bucket" "bad_bucket" {
  bucket = "enterprise-public-data-bucket-dev"

  tags = {
    Environment = "Dev"
    # Missing: CostCenter tag
  }
}

# Compliant Bucket: Fully encrypted, private access, properly tagged
resource "aws_s3_bucket" "good_bucket" {
  bucket = "enterprise-secure-logs-prod"

  tags = {
    Environment = "Production"
    CostCenter  = "FIN-99201"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "good_bucket_enc" {
  bucket = aws_s3_bucket.good_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "good_bucket_block" {
  bucket                  = aws_s3_bucket.good_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}