
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
}

output "nat_gateway_ip" {
  description = "NAT Gateway Elastic IP"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "Private Subnet 1 ID"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "Private Subnet 2 ID"
  value       = aws_subnet.private_2.id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.private.id
}

output "public_security_group_id" {
  description = "Public Security Group ID"
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "Private Security Group ID"
  value       = aws_security_group.private.id
}

output "vpc_summary" {
  description = "VPC Summary"
  value = {
    vpc_id             = aws_vpc.main.id
    cidr_block         = aws_vpc.main.cidr_block
    public_subnets    = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    private_subnets   = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    nat_gateway_ip    = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
    region             = var.aws_region
  }
}