output "provpc" {
  value = aws_vpc.provpc.id
}

output "proig" {
  value = aws_internet_gateway.proig.id
}

output "aval_1a_subnet" {
  value = aws_subnet.aval_1a_subnet.id
}

output "aval_1b_subnet" {
  value = aws_subnet.aval_1b_subnet.id
}

output "aval_1c_subnet" {
  value = aws_subnet.aval_1c_subnet.id
}

output "python_First_Instance_ami" {
  value = aws_ami_from_Instance.python_First_Instance_ami.id
}

output "python_First_Instance_ip" {
  value = aws_instance.python_First_Instance.public_ip
}

output "prosg" {
  value = aws_security_group.prosg.id
}


