# ----------------------- [ Basic Instance Dets ] ----------------------- #
resource "aws_instance" "payload-redirector" {
    ami             = var.amis["ubuntu"]
    instance_type   = "t2.micro"
    key_name        = "master_ssh_key"
    depends_on = [aws_instance.lighthouse] 

    vpc_security_group_ids =  [
        aws_security_group.http.id,
        aws_security_group.ssh.id,
        aws_security_group.nebula.id
    ]

# ----------------------- [ Connection Details ] ----------------------- #
    connection {
        host = self.public_ip
        user = "ubuntu"
        type = "ssh"
        private_key = file("~/.ssh/${var.aws_domain}")
        timeout = "10m"
    }

# ----------------------- [ Nebula Provisions ] ----------------------- #   

    provisioner "file" {
        source = "~/.ssh/${var.aws_domain}.pub"
        destination = "/tmp/${var.aws_domain}.pub"
    }

    provisioner "file" {
        source = "configs/nebula/redirectors.yaml"
        destination = "/tmp/${self.tags.Name}.yaml"
    }

    provisioner "file" {
        source = "certificates/ca.crt"
        destination = "/tmp/ca.crt"
    }
    
    provisioner "file" {
        source = "certificates/${self.tags.Name}.crt"
        destination = "/tmp/${self.tags.Name}.crt"
    }

    provisioner "file" {
        source = "certificates/${self.tags.Name}.key"
        destination = "/tmp/${self.tags.Name}.key"
    }

    provisioner "file" {
        source = "/tmp/nebula/nebula"
        destination = "/tmp/nebula"
    }    

    provisioner "file" {
        source = "files/payload-redirector-caddyfile"
        destination = "/tmp/Caddyfile"
    }

    provisioner "file" {
        source = "files/python3-https-webserver"
        destination = "/tmp/server.py"
    }
# ----------------------- [ Setup Commands ] ----------------------- #
    provisioner "remote-exec" {
        inline = [
            "sudo export PATH=$PATH:/usr/local/bin",
            "sudo export DEBIAN_FRONTEND=noninteractive",
            "echo '127.0.0.1 ${self.tags.Name}' | sudo tee -a /etc/hosts",
            "sudo hostnamectl set-hostname ${self.tags.Name}",
            "sudo apt-get update -y",
            "sudo apt-get upgrade -y",
            "sudo apt-get install at -y",
            "cat /tmp/${var.aws_domain}.pub >> /home/ubuntu/.ssh/authorized_keys",
            "rm /tmp/${var.aws_domain}.pub",
            "sudo wget ${var.caddy_download} -O caddy.tar.gz",
            "sudo tar -xvf caddy.tar.gz",
            "sudo mv caddy /usr/local/bin/caddy",
            "sudo chmod +x /usr/local/bin/caddy",
            "sudo rm caddy.tar.gz",
            "sudo mv /tmp/Caddyfile .",
            "sudo sed -i 's/PAYLOAD_DOMAIN/${var.aws_subdomain}.${var.aws_domain}/g' Caddyfile",
            "echo 'caddy run --watch' | sudo at now + 1 min",
            "sudo mkdir /etc/nebula",
            "sudo mv /tmp/${self.tags.Name}.* /etc/nebula",
            "sudo mv /tmp/ca.crt /etc/nebula",
            "sudo mv /tmp/nebula /etc/nebula/nebula",
            "sudo chmod +x /etc/nebula/nebula",
            "sudo sed -i 's/LIGHTHOUSE_IP_ADDRESS/${aws_instance.lighthouse.public_ip}/g' /etc/nebula/${self.tags.Name}.yaml",
            "sudo sed -i 's/HOST_NAME/${self.tags.Name}/g' /etc/nebula/${self.tags.Name}.yaml",
            "echo '/etc/nebula/nebula -config /etc/nebula/${self.tags.Name}.yaml' | sudo at now + 1 min",
            "sudo touch /tmp/complete.txt"
        ]
        on_failure = fail
      }
  
# ----------------------- [ Misc Tags ] ----------------------- #
    tags = {
        Name = "payload-redirector"
    }
}