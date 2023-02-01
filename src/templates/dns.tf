
data "aws_route53_zone" "primary" {
    name = var.aws_domain
}
  
resource "aws_route53_record" "root" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = var.aws_domain
    ttl     = 3600
    type    = "A"
    records = [aws_instance.teamserver-redirector.public_ip] 
    depends_on = [aws_instance.teamserver-redirector]
}
  
resource "aws_route53_record" "drop" {
    zone_id = data.aws_route53_zone.primary.zone_id
    name    = "${var.aws_subdomain}.${var.aws_domain}"
    type    = "A"
    ttl     = 3600
    records = [aws_instance.payload-redirector.public_ip]
    depends_on = [aws_instance.payload-redirector] 
}
