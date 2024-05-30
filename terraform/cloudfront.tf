resource "aws_cloudfront_distribution" "website_distribution" {
  #checkov:skip=CKV_AWS_68: we don't need WAF
  #checkov:skip=CKV_AWS_310: we don't need origin failover
  #checkov:skip=CKV_AWS_86: we don't need logging
  #checkov:skip=CKV2_AWS_47: WAF log4j thing
  #checkov:skip=CKV2_AWS_32: response headers are fine for now


  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.website_bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [local.turnhousedigital_domain, "www.${local.turnhousedigital_domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.turnhousedigital_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "OAI for S3 bucket access"
}

# resource "aws_cloudfront_distribution" "website_distribution" {
#   enabled = true

#   # aliases = [
#   #   aws_route53_record.turnhousedigital_www
#   # ]

#   origin {
#     domain_name = local.turnhousedigital_domain
#     origin_id = "turnhousedigital-s3-origin"
#   }

#   default_cache_behavior {
#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = "turnhousedigital-s3-origin"
#     viewer_protocol_policy = "redirect-to-https"

#     # Managed-CachingOptimized policy - default recommended for s3
#     cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       locations = []
#       restriction_type = "none"
#     }
#   }

#   price_class = "PriceClass_100"
#   is_ipv6_enabled = true
# }
