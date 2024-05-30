resource "aws_s3_bucket" "website_bucket" {
  #checkov:skip=CKV_AWS_21: we don't want versioning for now
  #checkov:skip=CKV_AWS_144: we don't want cross region replication
  #checkov:skip=CKV_AWS_18: we don't want logging
  #checkov:skip=CKV2_AWS_61: life cycyle config
  #checkov:skip=CKV2_AWS_62: we don't want to enable notifications
  #checkov:skip=CKV_AWS_70: we want everyone to be allowed to get the object
  #checkov:skip=CKV2_AWS_6: this is a public bucket
  #checkov:skip=CKV_AWS_145: we don't need encryption
  bucket        = local.turnhousedigital_domain
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  #checkov:skip=CKV_AWS_53: we want it to be publicly accessible
  #checkov:skip=CKV_AWS_54: we want the block public policy set to false
  #checkov:skip=CKV_AWS_56: this is a public bucket
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.bucket
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_access_policy" {
  #checkov:skip=CKV_AWS_70: we want everyone to be allowed to get the object 
  bucket = aws_s3_bucket.website_bucket.bucket
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.website_bucket.arn}/*"
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website_bucket_public_access]
}

resource "aws_s3_bucket_website_configuration" "website_bucket_website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}
