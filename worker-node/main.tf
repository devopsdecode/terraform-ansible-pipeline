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

    provisioner "remote-exec"{
        inline = ["echo 'wait until the ssh is ready'"]

        connection{
            type = "ssh"
            user = local.ssh_user
            private_key = file(local.private_key_path)
            host = aws_instance.nginx.public_ip
        }

    }
    provisioner "local-exec"{
        command = "ansible-playbook -i ${ aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yml"
    }

}

