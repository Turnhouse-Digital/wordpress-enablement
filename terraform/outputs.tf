output "name_servers_turnhousedigital" {
  value = aws_route53_zone.turnhousedigital.name_servers
}

output "name_servers_turnhousemarketing" {
  value = aws_route53_zone.turnhousemarketing.name_servers
}
