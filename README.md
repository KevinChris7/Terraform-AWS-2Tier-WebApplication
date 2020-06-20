# **Terraform-AWS-2Tier-WebApplication**

## **About Terraform**

Terraform is a tool used to Build,Configure and Version up the Infrastructure efficiently.

Terraform uses the configuration files to build and manage the Infrastructure

*Features of Terraform:*

1.Infrastructure as Code

2.Execution Planning

3.Resource Graph

4.Changes by Automation

## **About Project**

1.Builds the Web-DB Application Infrastructure in AWS

2.Monitors the Health of application instances

3.Notifies the members by SNS Topic

## **System requirements**

This version of packages and files was last tested on:

Ubuntu 20.04

Python 3.8

## **Infrastructure**

Ubuntu WSL - AWS Cloud

## **Development Environment**

Terraform v0.12.26

provider.aws v2.66.0

## **Usage**

1.Setup AWS CLI

2.Download and Install Terraform

3.Clone this repository

> git clone https://github.com/KevinChris7/Terraform-AWS-2Tier-WebApplication.git

4.Add the AWS access credentials as Environment Variables

> export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY HERE"

> export AWS_SECRET_ACCESS_KEY="YOUR SECRET ACCESS KEY HERE"

6.To Intialize the terraform directory

> terraform init

5.To Format the Terraform Config files

> terraform fmt

6.To Validate the Terraform Config files

> terraform validate

7.To Get the Plan of Terraform Config files

> terraform plan

8.To Execute the Terraform Config

> terraform apply

9.To Destroy or bring down the infrastructure

> terraform destroy

## **Project Insider**

- **Modules**: 1.infrastructure 2.application 3.monitoring

- **Test Infrastructure**: 

    1.Get the Loadbalancer DNS of Application instance

    2.Launch It

    3.Displays the Apache Homepage