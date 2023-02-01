
resource "aws_route53_zone" "primary" {
    name = "towerofterror.co.uk"
}

output "route53_zone_name_servers" {
  	description = "Name servers of Route53 zone"
  	value       = aws_route53_zone.primary.name_servers
}
