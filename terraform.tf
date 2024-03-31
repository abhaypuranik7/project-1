# provider
provider "aws" {
  region     = "us-east-1"
}

# create vpc
resource "aws_vpc" "myvpc" {
cidr_block = "10.0.0.0/16"
tags = {
Name = "myvpc"
}
}

# create publicsubnet
resource "aws_subnet" "publicsubnet" {
vpc_id = aws_vpc.myvpc.id
cidr_block = "10.0.1.0/24"
tags = {
Name = "public_subnet"
}
}
# create privatesubnet
resource "aws_subnet" "privatesubnet" {
vpc_id = aws_vpc.myvpc.id
cidr_block = "10.0.2.0/24"
tags = {
Name = "private_subnet"
}
}
# create internet gateway
resource "aws_internet_gateway" "gw" {
vpc_id = aws_vpc.myvpc.id
tags = {
Name = "myigw"
}
}
# create route table
resource "aws_route_table" "rt" {
vpc_id = aws_vpc.myvpc.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}
}
# create route table association
resource "aws_route_table_association" "a" {
subnet_id = aws_subnet.publicsubnet.id
route_table_id = aws_route_table.rt.id
}


# Create security group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.myvpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# create an instance
resource "aws_instance" "my_instance1" {
ami = "ami-07d9b9ddc6cd8dd30"
instance_type = "t2.medium"
associate_public_ip_address = true
subnet_id = aws_subnet.publicsubnet.id
key_name = "nvir"
tags = {
Name = "Jenkins"
}
vpc_security_group_ids  = [aws_security_group.my_security_group.id]
}

# create an instance
resource "aws_instance" "my_instance2" {
ami = "ami-07d9b9ddc6cd8dd30"
instance_type = "t2.micro"
count =2
subnet_id = aws_subnet.publicsubnet.id
associate_public_ip_address = true
key_name = "nvir"
tags = {
Name = "MyInstance"
}
vpc_security_group_ids  = [aws_security_group.my_security_group.id]
}
