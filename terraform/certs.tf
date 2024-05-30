resource "aws_acm_certificate" "turnhousedigital_cert" {
  provider = aws.us_east_1

  domain_name       = local.turnhousedigital_domain
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${local.turnhousedigital_domain}",
    local.turnhousemarketing_domain,
    "www.${local.turnhousemarketing_domain}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "turnhousedigital_cert"
  }
}

resource "aws_route53_record" "turnhousedigital_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.turnhousedigital_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.turnhousedigital.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "turnhousedigital_cert_validation" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.turnhousedigital_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.turnhousedigital_cert_validation : record.fqdn]
}
