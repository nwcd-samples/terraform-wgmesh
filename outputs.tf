output "public_ip_addr_zhy" {
  value       = aws_instance.wg_peer_zhy.public_ip
  description = "The public IP address of the main server instance."
}

/*
output "private_ip_addr_zhy" {
  value       = aws_instance.wg_peer_zhy.private_ip
  description = "The private IP address of the main server instance."
}
*/


output "public_ip_addr_bjs" {
  value       = aws_instance.wg_peer_bjs.public_ip
  description = "The public IP address of the main server instance."
}

/*
output "private_ip_addr_bjs" {
  value       = aws_instance.wg_peer_bjs.private_ip
  description = "The private IP address of the main server instance."
}
*/

output "public_subnet_cidr_zhy" {
  value       = data.aws_subnet.public_subnet_zhy.cidr_block
  description = "The CIDR block for Public Subnet in zhy"
}

output "public_subnet_cidr_bjs" {
  value       = data.aws_subnet.public_subnet_bjs.cidr_block
  description = "The CIDR block for Public Subnet in bjs"
}

