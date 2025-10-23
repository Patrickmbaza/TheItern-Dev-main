# # #Creare a security group
# resource "aws_security_group" "pat_sg" {
#  name        = "pat_sg"

# ingress {
#    from_port   = 0
#    to_port     = 65535
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
# egress {
#    from_port   = 0
#    to_port     = 65535
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
# }

# #Create an EC2 instance
# resource "aws_instance" "work-server" {
#   ami           = "ami-005fc0f236362e99f"
#   instance_type = "t2.small"
#   key_name      = "PatrickKP" 
#   count         = 1


#   security_groups = [aws_security_group.pat_sg.name]
# }





# output "public_ip" {
#   value = aws_instance.work-server[*].public_ip
# }


