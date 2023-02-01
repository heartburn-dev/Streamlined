import subprocess
import re

def write_dns_initializer(domain, subdomain):
	x = """
resource "aws_route53_zone" "primary" {
    name = \"DOMAIN_PLACEHOLDER\"
}

output "route53_zone_name_servers" {
  	description = "Name servers of Route53 zone"
  	value       = aws_route53_zone.primary.name_servers
}
"""
	config = x.replace("DOMAIN_PLACEHOLDER", domain)
	with open("dns.tf", "w") as f:
		f.write(config)

def terraform_dns_init():
	subprocess.call("terraform init", shell=True)
	subprocess.call("terraform apply -auto-approve", shell=True)
	output = subprocess.check_output("terraform output", shell=True)
	regex = r'\"(.*)\"'
	matches = re.findall(regex, output.decode(), re.MULTILINE)
	return matches

def match_nameservers(domain, nameservers):
	output = subprocess.check_output(f"aws route53domains update-domain-nameservers --domain-name {domain} --nameservers Name={nameservers[0]} Name={nameservers[1]} Name={nameservers[2]} Name={nameservers[3]} --region us-east-1", shell=True)
	print(output.decode())
