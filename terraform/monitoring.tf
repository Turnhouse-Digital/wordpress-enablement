resource "aws_route53_health_check" "turnhousedigital" {
  fqdn              = local.turnhousedigital_domain
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

}

resource "aws_sns_topic" "turnhousedigital_health" {
  #checkov:skip=CKV_AWS_26: we don't need encryption
  provider = aws.us_east_1
  name     = "turnhousedigital-health"
}

resource "aws_sns_topic_subscription" "turnhousedigital_health" {
  provider  = aws.us_east_1
  for_each  = toset(["tom@turnhousedigital.co.uk", "tomvaughan77@gmail.com", "sam.fallowfield1@gmail.com"])
  topic_arn = aws_sns_topic.turnhousedigital_health.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_metric_alarm" "turnhousedigital_health" {
  provider            = aws.us_east_1
  alarm_name          = "turnhousedigital-health-check-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "turnhousedigital-health-check-metric"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  namespace           = "AWS/Route53"

  dimensions = {
    HealthCheckId = aws_route53_health_check.turnhousedigital.id
  }

  alarm_actions = [
    aws_sns_topic.turnhousedigital_health.arn
  ]
}