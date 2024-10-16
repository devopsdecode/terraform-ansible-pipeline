locals {
    vpc_id = "<< update the vpc_id >>"
    subnet_id = "<< update the subnet_id >>"
    ssh_user = "ubuntu"
    key_name = "<< update the key_name >>"
    private_key_path = "<< update the key path >>"
}
provider "aws" {
    region = "ap-south-1"
    access_key = "<< Update the access_key >>"
    secret_key = "<< Update the "secret_key >>
}

resource "aws_security_group" "nginx" {
    name = "nginx_access"
    vpc_id = local.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }        

}

resource "aws_instance" "nginx" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t3.small"
    subnet_id = local.subnet_id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.nginx.id]
    key_name = local.key_name
  
  tags = {
    Name        = "ansible-master-node"
  }

    provisioner "remote-exec"{
  inline = [
    "echo 'wait until the ssh is ready' || true",
    "sudo apt update -y || true",
    "sudo apt install ansible -y || true",
    # Install Terraform using HashiCorp's official repo
    "sudo apt-get install -y gnupg software-properties-common curl || true",
    "wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg || true",
    # Ensure the correct interpretation of $(lsb_release -cs)
    "echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list || true",
    "sudo apt update && sudo apt install terraform -y || true"
  ]

        connection{
            type = "ssh"
            user = local.ssh_user
            private_key = file(local.private_key_path)
            host = aws_instance.nginx.public_ip
        }

    }
    provisioner "local-exec"{
        command = "echo 'Ansible and Terraform installed successfully!'"
    }

}

