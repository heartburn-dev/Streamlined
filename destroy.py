# C2 infrastructure provisioner and domain auto-handler with AWS
# Author: Toby Jackson

import os
import sys
from time import *
from dns import *

def destroy():
	subprocess.call("terraform -chdir=src/templates destroy -auto-approve", shell=True)
	subprocess.call("terraform destroy -auto-approve", shell=True)
	print("[*] Destruction complete!")

if __name__ in "__main__":

	destroy()
