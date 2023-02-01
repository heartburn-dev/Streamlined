output "lighthouse" {
    value = aws_instance.lighthouse.public_ip
  }
  
  output "teamserver-redirector" {
    value = aws_instance.teamserver-redirector.public_ip
  }
  
  output "payload-redirector" {
    value = aws_instance.payload-redirector.public_ip
  }
  
  output "payloads" {
    value = aws_instance.payloads.public_ip
  }
  
  output "teamserver" {
    value = aws_instance.teamserver.public_ip
  }