resource "aws_key_pair" "master_ssh_key" {
    key_name   = "master_ssh_key"
    public_key = file("/home/${var.current_username}/.ssh/${var.aws_domain}.pub")
}

resource "aws_security_group" "ssh" {
    name          = "ssh"

    ingress {
      from_port   = 0
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["82.10.143.106/32"]
    }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

resource "aws_security_group" "http" {
    name          = "http"

    ingress {
      from_port   = 0
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
      from_port   = 0
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  resource "aws_security_group" "nebula" {
    name          = "nebula"

    ingress {
      from_port   = 0
      to_port     = 4242
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      from_port   = 0
      to_port     = 4242
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }