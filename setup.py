# C2 infrastructure provisioner and domain auto-handler with AWS
# Author: Toby Jackson

import os
import sys
from time import *
from dns import *
import getpass

def usage():
	print("[?] Usage: python3 setup.py <domain_name> <redirector_subdomain>")
	sys.exit()

def check(domain, subdomain):
	print(f"[?] You are about to setup C2 infrastructure using the {domain} domain with the {subdomain} subdomain acting as a redirector, hit any key to continue!")
	input()

def replace_domains(domain, subdomain):
	current_user = getpass.getuser()
	with open ("src/templates/variables.tf", "r") as f:
		variable_file = f.read()

	variable_file = variable_file.replace("C2_DOMAIN", domain).replace("C2_SUBDOMAIN", subdomain).replace("CURRENT_USER", current_user)

	with open ("src/templates/variables.tf", "w") as f:
		f.write(variable_file)

if __name__ in "__main__":
	
	if len(sys.argv) != 3:
		usage()

	domain = sys.argv[1]
	subdomain = sys.argv[2]

	check(domain, subdomain)
	replace_domains(domain, subdomain)

	write_dns_initializer(domain, subdomain)
	nameservers = terraform_dns_init()
	match_nameservers(domain, nameservers)

	subprocess.call(f"src/templates/keys/keygen.sh {domain}", shell=True)
	subprocess.call("terraform -chdir=src/templates init", shell=True)
	subprocess.call("terraform -chdir=src/templates apply -auto-approve", shell=True)

	print("[*] Deployment complete! Run destroy.py to destroy the infrastructure.")