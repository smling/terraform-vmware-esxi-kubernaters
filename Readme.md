# Terraform VMWare ESXi Kuberneters node #

Terraform files to setup kubernates in VWWare ESXi.

As default provider require to call vSheaper API, which does bh  enable 

## Pre-requests ##
1. SSH client shold be enable in ESXi server;
2. In terraform execute host, [ovftools](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=OVFTOOL443) is required to install;
3. using key to connect new host and config via ssh. requeire ssh key. use command  `ssh-keygen` to generate public key and private key'
4. it using ubuntu as sample. As ubuntu cloud image require reset password for first time ssh login, so it will create custom ovf file to resolve it;
5. EXSi host and password are store in `terraform.tfvar`. However it add to .gitignore to prevent senitive information leakage;

## Usage ##
Sample command as below.
```sh
cd $REPO_PATH
terraform init
terraform plan
terraform apply -autoapprove
```