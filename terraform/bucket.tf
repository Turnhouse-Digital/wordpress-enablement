
resource "aws_s3_bucket" "website_bucket" {
    #checkov:skip=CKV_AWS_21: we don't want versioning for now
    #checkov:skip=CKV_AWS_144: we don't want cross region replication
    #checkov:skip=CKV_AWS_18: we don't want logging
  bucket = "${locals.account_id}-website-bucket"
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
    description = "This key is used to encrypt website-bucket objects"
    deletion_window_in_days = 7
 }

 resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
    bucket = aws_s3_bucket.website_bucket.bucket
    block_public_acls = false
    block_public_policy = false
 }

 resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
    bucket = aws_s3_bucket.website_bucket.bucket
    versioning_configuration {
        status = "disabled"
    }
 }

