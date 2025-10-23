terraform {
  cloud {

    organization = "Goteh-Oganisation"

    workspaces {
      name = "goteh01"
    }
  }
}




# # How to migrate my state file to an s3 bucket
#  resource "aws_s3_bucket" "bucket" {
#   bucket = "my-tf-state-bucket2122"
#   force_destroy = true

#   tags = {
#     Name        = "pat-bucket"
#     Environment = "Dev"
#   }
# } 

# resource "aws_dynamodb_table" "basic-dynamodb-table" {
#   name           = "terraform-s3-locking-table"
#   read_capacity  = 20
#   write_capacity = 20
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }


# terraform {
#   backend "s3" {
#     bucket           = "my-tf-state-bucket2122"
#     dynamodb_table = "terraform-s3-locking-table"
#     region         = "us-east-1"
#     encrypt        = true
#     key = "mbaza-terraform-terraform-s3-backend/terraform.tfstate"

#   }
# }

