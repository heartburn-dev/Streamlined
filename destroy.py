# C2 infrastructure provisioner and domain auto-handler with AWS
# Author: Toby Jackson
import subprocess
import sys
import getpass

def usage():
	print("[?] Usage: python3 destroy.py <domain_name> <redirector_subdomain>")
	sys.exit()

def destroy():
	subprocess.call("terraform -chdir=src/templates destroy -auto-approve", shell=True)
	subprocess.call("terraform destroy -auto-approve", shell=True)
	print("[*] Destruction complete!")

def replace_domains(domain, subdomain):
	current_user = getpass.getuser()
	with open ("src/templates/variables.tf", "r") as f:
		variable_file = f.read()

	variable_file = variable_file.replace(current_user, "CURRENT_USER").replace(subdomain, "C2_SUBDOMAIN").replace(domain, "C2_DOMAIN")

	with open ("src/templates/variables.tf", "w") as f:
		f.write(variable_file)

if __name__ in "__main__":

	if len(sys.argv) != 3:
		usage()

	domain = sys.argv[1]
	subdomain = sys.argv[2]

	destroy()
	replace_domains(domain, subdomain)
