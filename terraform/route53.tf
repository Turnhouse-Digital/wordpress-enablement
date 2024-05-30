data "aws_route53_zone" "turnhousedigital" {
  name = local.turnhousedigital_domain
}

data "aws_route53_zone" "turnhousemarketing" {
  name = local.turnhousedigital_domain
}

resource "aws_route53_record" "turnhousedigital_root" {
  zone_id = data.aws_route53_zone.turnhousedigital.zone_id
  name    = local.turnhousedigital_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "turnhousedigital_www" {
  zone_id = data.aws_route53_zone.turnhousedigital.zone_id
  name    = "www.${local.turnhousedigital_domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "turnhousemarketing_root" {
  zone_id = data.aws_route53_zone.turnhousemarketing.zone_id
  name    = local.turnhousemarketing_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "turnhousemarketing_www" {
  zone_id = data.aws_route53_zone.turnhousemarketing.zone_id
  name    = "www.${local.turnhousemarketing_domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
