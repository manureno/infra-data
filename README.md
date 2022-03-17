# Infrastructure Template for IBM Cloud

This repository  contains Terraform templates to create an IBM Cloud infrastructure including:
* A Virtual Private Cloud
* A Kubernetes Cluster
* A Cloud Object Storage bucket
* A Container Registry Namespace
* A Resource Group


## Infrastructure Overview

![alt text](res/infra-template.jpg)

## Project Structure
```
infra-ibm.tf
   +- README.md : This file
   +- main.tf : Resources creation instructions
   +- variables.tf : Defaulted and mandatory variables 
```

## Configuring the Templates
Terraform variables are used to configure the Templates :

- Structure organization/application and environment  
  + **org** : code name of an organization hosting applications   
  + **app** : code name of an application hosted in an organization  
  + **env** : code name of en environment in which to deploy the application (dev, uat, etc. )


- Connection to IBM Cloud
  + **ibmcloud_api_key** : IBM Cloud IAM key used to provision resources  


## Executing the Templates

Terraform templates may be executed from IBM Cloud Schematics : https://cloud.ibm.com/schematics


## ibmcloud CLI _mini cheat sheet_

* List available zones 
```
$ ibmcloud ks locations
```

* List available machines flavors
```
$ ibmcloud ks flavors --zone LOCATION
```
_Ex for VPC Zone eu-de-1 : bx2.2x8_  
_Ex for Classic Zone fra02 : b3c.4x16_

## Resources
Terraform : https://www.terraform.io/  
IBM Cloud Provider for Terraform : https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs  
VPC Cluster Creation Sample : https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/container_vpc_cluster  