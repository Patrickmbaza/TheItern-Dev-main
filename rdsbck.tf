

# # Create a VPC
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "main-vpc"
#   }
# }

# # Create a Subnet
# resource "aws_subnet" "main" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a" # Replace with your preferred AZ
#   tags = {
#     Name = "main-subnet"
#   }
# }

# resource "aws_subnet" "sub-subnet" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-east-1b" # Replace with your preferred AZ
#   tags = {
#     Name = "sub-subnet"
#   }
# }

# # Create a Security Group for EC2
# resource "aws_security_group" "ec2_sg" {
#   name        = "ec2-sg"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow SSH access (modify for security)
#   }

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     #security_groups = [aws_security_group.rds_sg.id] # Allow RDS connections
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ec2-security-group"
#   }
# }

# # Create a Security Group for RDS
# resource "aws_security_group" "rds_sg" {
#   name        = "rds-sg"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     security_groups = [aws_security_group.ec2_sg.id] # Allow EC2 connections
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "rds-security-group"
#   }
# }

# # Create an EC2 Instance
# resource "aws_instance" "ec2-instance" {
#   ami           = "ami-0866a3c8686eaeeba" # Replace with your AMI
#   instance_type = "t2.micro"
#   key_name = "PatrickKP"
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]
#   subnet_id              = aws_subnet.main.id 

#   tags = {
#     Name = "ec2-instance"
#   }
# }

# # Create an RDS Instance
# resource "aws_db_instance" "database" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t3.micro"
#   db_name                 = "exampledb"
#   username             = "admin"
#   password             = "password123" # Replace with a strong password
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   skip_final_snapshot  = true
#   publicly_accessible  = false
#   db_subnet_group_name = aws_db_subnet_group.main.name
# }

# # Create a DB Subnet Group
# resource "aws_db_subnet_group" "main" {
#   name       = "main-db-subnet-group"
#   subnet_ids = [aws_subnet.main.id, aws_subnet.sub-subnet.id]

#   tags = {
#     Name = "main-db-subnet-group"
#   }
# }

# # Outputs
# output "ec2_ip" {
#   value = aws_instance.ec2-instance.public_ip
# }

# output "rds_endpoint" {
#   value = aws_db_instance.database.endpoint
# }
