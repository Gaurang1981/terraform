# How to use this repo

1. Clone the repo.

2. Create a private key file.
   
   ssh-keygen -t rsa -b 4096

3. Create terraform.tfvars in the terraform\windows-server folder and configure the following variables.

   key_pair_name = "mykey"  
   public_key_name = "C:\\Users\\gaurang\\.ssh\\mykey.pub"  
   private_key_name = "C:\\Users\\gaurang\\.ssh\\mykey"    
   server_type = "t2.micro"  
   aws_region = "ap-south-1" 

4. Run "terraform init" to initialize the working directory.

5. Run "terraform apply" to create resources.