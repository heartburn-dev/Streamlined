resource "null_resource" "clear_configs" {
  triggers = {
    domain = var.aws_domain
  }
    provisioner "local-exec" {
      when = destroy
      command = <<-EOT
        rm certificates/*
        rm ~/.ssh/${self.triggers.domain}*
        rm -rf /tmp/nebula*
      EOT
      interpreter = ["/usr/bin/env", "bash", "-c"]
    }
  }
  