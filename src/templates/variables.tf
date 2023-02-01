variable "aws_domain" {
    description = "Domain used in the engagement"
    default = "towerofterror.co.uk"
}

variable "current_username" {
  type = string
  default = "kali"
  description = "The user running the script. Needed to write to home directory as $HOME and ~/ was breaking... Sporadically..."
}

variable "amis" {
    type = map
    default = {
      "ubuntu"  = "ami-035469b606478d63d"
      "kali" = "ami-0977c7cb43e178584"
    }
  }

variable "key_name" {
    type = string
    description = "The initial SSH key used for all servers (update to a more secure method later)"
    default = "master_ssh_key"
}

variable "cert_name" {
    type = string
    description = "Name to go on the CA cert generated by Nebula"
    default = "Tower of Terror, Hollywood CA"
}

variable "caddy_download" {
    type = string
    description = "The download link for the tar.gz caddy files, update to ensure the most recent version!"
    default = "https://github.com/caddyserver/caddy/releases/download/v2.6.2/caddy_2.6.2_linux_amd64.tar.gz"
  }

  variable "aws_subdomain" {
    type = string 
    description = "The subdomain to host a seperate payload server"
    default = "drop"
  }

#  data "http" "my_source_ip" {
#    url = "https://ipv4.icanhazip.com"
#  }