resource "aws_route53_zone" "turnhousedigital" {
  #checkov:skip=CKV2_AWS_39: don't need logging on the domain for now
  #checkov:skip=CKV2_AWS_38: TODO: re-enable and setup DNSSEC
  name = "turnhousedigital.co.uk"
}

# resource "aws_route53_key_signing_key" "ksk" {
#   name                       = "ksk-1"
#   hosted_zone_id             = aws_route53_zone.turnhousedigital.zone_id
#   key_management_service_arn = aws_kms_key.key_signing_key.arn

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_hosted_zone_dnssec" "ksk" {
#   hosted_zone_id = aws_route53_key_signing_key.ksk.hosted_zone_id

#   depends_on = [aws_route53_key_signing_key.ksk]
# }

resource "aws_route53_record" "turnhousedigital_www" {
  zone_id = aws_route53_zone.turnhousedigital.zone_id
  name    = "www.turnhousedigital.co.uk"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website_bucket_website_config.website_endpoint
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "turnhousedigital_root" {
  zone_id = aws_route53_zone.turnhousedigital.zone_id
  name    = "turnhousedigital.co.uk"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website_bucket_website_config.website_endpoint
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_zone" "turnhousemarketing" {
  #checkov:skip=CKV2_AWS_39: don't need logging on the domain for now
  #checkov:skip=CKV2_AWS_38: TODO: re-enable and setup DNSSEC
  name = "turnhousemarketing.co.uk"
}

resource "aws_route53_record" "turnhousemarketing_www" {
  zone_id = aws_route53_zone.turnhousemarketing.zone_id
  name    = "www.turnhousemarketing.co.uk"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website_bucket_website_config.website_endpoint
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "turnhousemarketing_root" {
  zone_id = aws_route53_zone.turnhousemarketing.zone_id
  name    = "turnhousemarketing.co.uk"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.website_bucket_website_config.website_endpoint
    zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
