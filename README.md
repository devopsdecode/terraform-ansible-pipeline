Ansible and Terraform Pipeline Setup

Introduction

This repository contains Ansible and Terraform code to set up a deployment pipeline for NGINX on an EC2 instance. The provided scripts automate the provisioning of the infrastructure with Terraform and the configuration of NGINX using Ansible.

Features

Infrastructure Provisioning: Use Terraform to provision an EC2 instance in AWS.
Configuration Management: Utilize Ansible to install and configure NGINX on the provisioned instance.
Automated Deployment: Seamlessly integrate the two tools for an efficient deployment process.

Prerequisites

An AWS account with appropriate permissions.
Terraform installed on your local machine.
Ansible installed on your local machine.
AWS CLI configured with your AWS credentials or update the creadenails in main.tf
Create the ssh key and and map in main.tf key path

------------------------------------

Directory Structure

There are two directories in this project:

ansible-master-instance

This Terraform configuration will create a single Ansible and Terraform master node, replicating a real-world scenario.

worker-node

This directory allows you to directly create a worker node (client server) from your local laptop or any master node where Terraform and Ansible are pre-installed.


ABC
