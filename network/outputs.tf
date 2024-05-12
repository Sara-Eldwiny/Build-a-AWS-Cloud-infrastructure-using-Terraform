output subnetpub1 {
  value       = aws_subnet.public1
  sensitive   = true
  
}
output subnetpub2 {
  value       = aws_subnet.public2
  sensitive   = true
  
}
output subnetpriv1 {
  value       = aws_subnet.private1
  sensitive   = true
  
}

output subnetpriv2 {
  value       = aws_subnet.private2
  sensitive   = true
  
}
output vpc_id {
    value = aws_vpc.main.id
}
output vpc_cidr{
    value = aws_vpc.main.cidr_block
}