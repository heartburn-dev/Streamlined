resource "null_resource" "init" {
    provisioner "local-exec" {
        command = <<-EOT
            # Install Nebula
            mkdir /tmp/nebula 
            wget https://github.com/slackhq/nebula/releases/download/v1.6.1/nebula-linux-amd64.tar.gz -O /tmp/nebula.tar.gz
            tar -xvf /tmp/nebula.tar.gz -C /tmp/nebula
            cd certificates && /tmp/nebula/nebula-cert ca -name var.cert_name
            /tmp/nebula/nebula-cert sign -name "lighthouse" -ip "10.69.69.1/24"
            /tmp/nebula/nebula-cert sign -name "teamserver-redirector" -ip "10.69.69.2/24" -groups "redirectors"
            /tmp/nebula/nebula-cert sign -name "payload-redirector" -ip "10.69.69.3/24" -groups "redirectors"
            /tmp/nebula/nebula-cert sign -name "payloads" -ip "10.69.69.4/24" -groups "critical"
            /tmp/nebula/nebula-cert sign -name "teamserver" -ip "10.69.69.5/24" -groups "critical"
            /tmp/nebula/nebula-cert sign -name "operator_1" -ip "10.69.69.100/24" -groups "operator"
            /tmp/nebula/nebula-cert sign -name "operator_2" -ip "10.69.69.101/24" -groups "operator"
            /tmp/nebula/nebula-cert sign -name "operator_3" -ip "10.69.69.102/24" -groups "operator"
            /tmp/nebula/nebula-cert sign -name "operator_4" -ip "10.69.69.103/24" -groups "operator"
          EOT
          interpreter = ["/usr/bin/env", "bash", "-c"]
    }
}