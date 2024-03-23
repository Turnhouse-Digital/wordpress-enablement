resource "aws_s3_bucket" "website_bucket" {
  #checkov:skip=CKV_AWS_21: we don't want versioning for now
  #checkov:skip=CKV_AWS_144: we don't want cross region replication
  #checkov:skip=CKV_AWS_18: we don't want logging
  #checkov:skip=CKV2_AWS_61: life cycyle config
  #checkov:skip=CKV2_AWS_62: We don't want to enable notifications
  #checkov:skip=CKV_AWS_70: We want everyone to be allowed to get the object 
  bucket = "${local.account_id}-website-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_bucket_sse_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.website_bucket_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "website_bucket_kms_key" {
  #checkov:skip=CKV_AWS_33: we want to apply wildcard
  description             = "This key is used to encrypt website-bucket objects"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Effect : "Allow",
      Principal : "*",
      Action : [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
        "kms:Update",
      ],
      Resource : "*",
      Condition : {
        StringEquals : {
          "kms:ViaService"                   = "s3.eu-west-2.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn" = aws_s3_bucket.website_bucket.arn
        }
      }
    }]
  })
}



resource "aws_iam_role" "website_bucket_role" {
  name               = "website_bucket_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  #checkov:skip=CKV_AWS_53: We want it to be publicly accessible
  #checkov:skip=CKV_AWS_54: we want the block public policy set to false
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.bucket
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_access_policy" {
  #checkov:skip=CKV_AWS_70: We want everyone to be allowed to get the object 
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Sid" : "PublicReadGetObject",
      "Effect" : "Allow",
      "Principal" : "*",
      "Action" : "s3:GetObject",
    "Resource" : "${aws_s3_bucket.website_bucket.arn}/*" }]
  })
}

output "website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}