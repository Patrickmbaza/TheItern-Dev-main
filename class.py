# TO CREATE AN EC2-INSTANCE
# import boto3
# ec2 = boto3.resource('ec2')
# # create a new EC2 instance
# instances = ec2.create_instances(
#     ImageId='ami-0866a3c8686eaeeba',
#     InstanceType='t2.micro',
#     KeyName='pub KP',
#     #SecurityGroupIds=['sg-0763a0c175a339a56'],
#     #tag the instance with a name 
#     TagSpecifications=[{
#         'ResourceType': 'instance',
#         'Tags': [{
#             'Key': 'Name',
#             'Value': 'Dev-server'
#         }]
#     }],
#     #number of instances to launch 
#     MaxCount=3,
#     MinCount=3, 
# )

# PRINT OUT INSTANCE ID AND IP ADDRESS
# import boto3
# ec2 = boto3.resource('ec2')
# for instance in ec2.instances.all():
#     print(instance.id, instance.public_ip_address)

# TERMINATE MULTIPLR INSTANCES
# import boto3
# ec2 = boto3.resource('ec2')
# instances = ec2.instances.filter(
#     Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
# for instance in instances:
#     print(instance.id, instance.instance_type)
#     instance.terminate()
#     print("Delete server " + instance.id, instance.state)
#     print("...server deleted")


# CREATE AN S3 BUCKET
# import boto3
# # Initialize the S3 client
# s3_client = boto3.client('s3', region_name='us-east-1')

# # Specify a unique bucket name
# bucket_name = 'crim02bucket'

# # Create an S3 bucket
# s3_client.create_bucket(Bucket=bucket_name)
# print(f"S3 bucket '{bucket_name}' done")

# print("S3 bucket job done.")

# PRINT EXISTING BUCKET
# import boto3
# s3= boto3.client('s3')
# response= s3.list_buckets()
# print('Existing buckets:')
# for bucket in response ['Buckets']:
#     print(f'  {bucket["Name"]}')


# To delete and s3 bucket
# import boto3
# s3 = boto3.resource('s3')
# bucket = s3.Bucket('crim02bucket')
# #bucket.objects.all().delete()
# s3.Bucket('crim02bucket').delete()


# TO CREATE A vpc and internet gateway
# import boto3
# ec2 = boto3.resource('ec2' , region_name = 'us-east-1')
# ec2 = boto3.resource('ec2')
# vpc = ec2.create_vpc(CidrBlock='10.0.0.0/16')
# vpc.wait_until_available()
# vpc.create_tags(Tags=[{"Key": "Name", "Value": "crim_vpc"}])
# vpc.modify_attribute(EnableDnsSupport={'Value': True})
# vpc.modify_attribute(EnableDnsHostnames={'Value': True})
# #To create an igw
# ig = ec2.create_internet_gateway()
# vpc.attach_internet_gateway(InternetGatewayId=ig.id)
# print(vpc.id)
# print(ig.id)


# TERMINATE VPC AND INTERNETGATEWAY
# import boto3
# ec2 = boto3.resource('ec2' , region_name = 'us-east-1')
# ec2 = boto3.resource('ec2')
# vpc = ec2.Vpc('vpc-09d7d5e009c449db1')#//Replace the printed vpc id with the valaue here
# ig = ec2.InternetGateway('igw-0516557bb862234fa')
# vpc.detach_internet_gateway(InternetGatewayId=ig.id)#//Repalce the printed igw id with the value here
# ig.delete()
# vpc.delete()
# # print(vpc.id gone)
# # print(ig.id gone)

# TO CREATE A VPC AND SUBNET
# import boto3

# # Initialize the EC2 client
# ec2_client = boto3.client('ec2', region_name='us-east-1')

# # Create a VPC
# vpc_response = ec2_client.create_vpc(CidrBlock='10.0.0.0/16')
# vpc_id = vpc_response['Vpc']['VpcId']
# print(f"VPC created with ID: {vpc_id}")

# # Add a name tag to the VPC
# ec2_client.create_tags(Resources=[vpc_id], Tags=[{'Key': 'Name', 'Value': 'crimVPC'}])
# print("VPC tagged with 'Name: crimVPC'")

# # Create a subnet within the VPC
# subnet_response = ec2_client.create_subnet(
#     VpcId=vpc_id,
#     CidrBlock='10.0.1.0/24',
#     AvailabilityZone='us-east-1a'
# )
# subnet_id = subnet_response['Subnet']['SubnetId']
# print(f"Subnet created with ID: {subnet_id}")

# print("VPC provisioning completed.")


# TO DELETE SUBNET AND VPC
# import boto3

# # Initialize the EC2 client
# ec2_client = boto3.client('ec2', region_name='us-east-1')

# # Specify the subnet ID of the subnet you want to delete
# subnet_id = 'subnet-0aa699d6b4b4072da'

# # Delete the subnet
# ec2_client.delete_subnet(SubnetId=subnet_id)
# print(f"Deleting subnet with ID: {subnet_id}")

# # Specify the VPC ID of the VPC you want to delete
# vpc_id = 'vpc-09ebabb189b2fce24'

# # Delete the VPC
# ec2_client.delete_vpc(VpcId=vpc_id)
# print(f"Deleting VPC with ID: {vpc_id}")

# print("VPC and subnet deletion initiated.")