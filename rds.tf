# # #Create a VPC
# resource "aws_vpc" "pat-vpc" {
# cidr_block = "10.0.0.0/16"
# tags = {
# Name = "pat-vpc"
# }
# }


# # #create internet gateway
# resource "aws_internet_gateway" "pat-gw" {
#   vpc_id = aws_vpc.pat-vpc.id

#   tags = {
#     Name = "pat-gw"
#   }
# }


# # #create a route table
# resource "aws_route_table" "pat-rt" {
#   vpc_id = aws_vpc.pat-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.pat-gw.id
#   }

#   tags = {
#     Name = "pat-rt"
#   }
# }

# # #create public subnet
# resource "aws_subnet" "public-subnet" {
#   vpc_id     = aws_vpc.pat-vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1d"

#   tags = {
#     Name = "public-subnet"
#   }
# }


# # #create private subnet
# resource "aws_subnet" "private-subnet" {
#   vpc_id     = aws_vpc.pat-vpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-east-1f"

#   tags = {
#     Name = "private-subnet"
#   }
# }


# resource "aws_subnet" "private-subnet2" {
#   vpc_id     = aws_vpc.pat-vpc.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "private-subnet2"
#   }
# }


# # #Associate public subnet with route table
# resource "aws_route_table_association" "route-pub" {
#   subnet_id      = aws_subnet.public-subnet.id
#   route_table_id = aws_route_table.pat-rt.id
# }


# # Create an web security group
# resource "aws_security_group" "pat_db_sg" {
#   name        = "pat_db_sg"
#   description = "Security group for web server"
#   vpc_id      = aws_vpc.pat-vpc.id


#   ingress {
#     description = "Allow all traffic through HTTP"
#     from_port   = "80"
#     to_port     = "80"
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#     ingress {
#     description = "Allow SSH from my computer"
#     from_port   = "22"
#     to_port     = "22"
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  
#    tags = {
#     Name = "pat_db_sg"
#   }
# }

# #Create security group for RDS instance
# resource "aws_security_group" "pat2_db_sg" {
#   name        = "pat2_db_sg"
#   description = "Security group for my databases"
#   vpc_id      = aws_vpc.pat-vpc.id
#     ingress {
#     description     = "Allow MySQL traffic from only the web sg"
#     from_port       = "3306"
#     to_port         = "3306"
#     protocol        = "tcp"
#     security_groups = [aws_security_group.pat_db_sg.id]
#   }

#   tags = {
#     Name = "pat2_db_sg"
#   }
# }

# resource "aws_db_subnet_group" "pat_subnet_group" {
#   name        = "pat_db_subnet_group"
#   description = "DB subnet group for MySQL database"
#   subnet_ids  = [aws_subnet.private-subnet.id, aws_subnet.private-subnet2.id]
# }

# #Create a network interface
# resource "aws_network_interface" "test" {
#   subnet_id       = aws_subnet.public-subnet.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.pat_db_sg.id]
# }

# resource "aws_eip" "one" {
#   domain                    = "vpc"
#   network_interface         = aws_network_interface.test.id
#   associate_with_private_ip = "10.0.1.50"
# }

# // Create an EC2 instance named "pat_web"
# resource "aws_instance" "pat_web" {
#   ami                    = "ami-005fc0f236362e99f"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.public-subnet.id 
#   key_name               = "PatrickKP"   
#   vpc_security_group_ids = [aws_security_group.pat_db_sg.id]
#   tags = {
#     Name = "pat_web"
#   }
# }

# resource "aws_db_instance" "Pat_database" {
#  allocated_storage      = 20
#  identifier             = "patdb"
#   engine                 = "mysql"
#   engine_version         = "5.7"
#   instance_class         = "db.t3.micro"
#   username = var.db_username
#   password = var.db_password
#   db_name                = "Pat_database"
#   parameter_group_name   = "default.mysql5.7"
#   skip_final_snapshot    = true
#   db_subnet_group_name   = aws_db_subnet_group.pat_subnet_group.id
#   vpc_security_group_ids = ["${aws_security_group.pat_db_sg.id}"]
# }



# output "rds_endpoint" {
#   description = "The endpoint of the RDS instance"
#   value = aws_db_instance.Pat_database.endpoint
# }


# output "public_ip" {
#   value = aws_instance.pat_web[*].public_ip
# }


