#Create a VPC
resource "aws_vpc" "pat-vpc" {
cidr_block = "10.0.0.0/16"
tags = {
Name = "pat-vpc"
}
}


#create internet gateway
resource "aws_internet_gateway" "pat-gw" {
  vpc_id = aws_vpc.pat-vpc.id

  tags = {
    Name = "pat-gw"
  }
}


#create a route table
resource "aws_route_table" "pat-rt" {
  vpc_id = aws_vpc.pat-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pat-gw.id
  }

  tags = {
    Name = "pat-rt"
  }
}


#create public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.pat-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}


#create private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.pat-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}


#Associate public subnet with route table
resource "aws_route_table_association" "route-sub" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.pat-rt.id
}

#Creare a security group
resource "aws_security_group" "pat_sg" {
 name        = "pat_sg"
 description = "Allow HTTPS, SSH and HTTP to web server"
 vpc_id      = aws_vpc.pat-vpc.id

ingress {
   description = "HTTPS ingress"
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
   description = "SSH ingress"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 
ingress {
   description = "for HTTP"
   from_port   = 80
   to_port     = 80
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

#Create a network interface
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.public-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.pat_sg.id]
}

#Create an EIP
resource "aws_eip" "pat-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.test.id
  associate_with_private_ip = "10.0.1.50"
}


 # Create an EC2 instance
resource "aws_instance" "server" {
  ami           = "ami-0866a3c8686eaeeba" 
  instance_type = "t2.micro"
  key_name      = "PatrickKP" 

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }
}

# output "public_ip" {
#   value = aws_instance.server[*].public_ip
# }




# module "s3_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "my-s3-bucket"
#   acl    = "public"

#   control_object_ownership = true
#   object_ownership         = "ObjectWriter"

#   versioning = {
#     enabled = true
#   }
# }





 