terraform {
  required_version = "~> 1.4.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "win-key" {
  key_name = var.key_pair_name
  public_key = file(var.public_key_name)
}

resource "aws_security_group" "windows-sg" {
    name = "windows-rdp-sg"
    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "allow RDP"
      from_port = 3389
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = 3389
    } ]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "allow all traffic"
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = []
      self = false
      to_port = 0
    } ]
}

resource "aws_instance" "download-server" {
  ami = "ami-0bd3f43f107376d6b"
  instance_type = var.server_type
  security_groups = ["windows-rdp-sg"]
  get_password_data = true
  key_name = aws_key_pair.win-key.key_name
}

output "server-ip" {
  value = aws_instance.download-server.public_ip
}

# output "Administrator_Password" {
#    value = aws_instance.download-server.password_data
# }

output "password_decrypted" {
  value=rsadecrypt(aws_instance.download-server.password_data, file(var.private_key_name) ) 
}