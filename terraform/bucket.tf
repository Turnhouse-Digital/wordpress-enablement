
resource "aws_s3_bucket" "website_bucket" {
    #checkov:skip=CKV_AWS_21: we don't want versioning for now
    #checkov:skip=CKV_AWS_144: we don't want cross region replication
    #checkov:skip=CKV_AWS_18: we don't want logging
    #checkov:skip=CKV2_AWS_61: life cycyle config
    #checkov:skip=CKV2_AWS_62: We don't want to enable notifications
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
    enable_key_rotation = true
 }

 resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
    bucket = aws_s3_bucket.website_bucket.bucket
    # block_public_acls = false
    # block_public_policy = false
    block_public_acls = true
    block_public_policy = true
    restrict_public_buckets = true
    ignore_public_acls = true
 }

 resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
    bucket = aws_s3_bucket.website_bucket.bucket
    versioning_configuration {
        status = "disabled"
    }
 }

