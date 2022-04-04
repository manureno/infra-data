terraform {
  required_providers {
    ibm = {
      source = "ibm-cloud/ibm"
	  version = "1.39.1"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region = "${var.region}"
  # generation = 2
}

#
# Resource Group for an environment : rg-org-env
#
resource "ibm_resource_group" "resource_group" {
  name = "rg-${var.org}-${var.env}"
}

#
# Container Registry Namespace for an application : ns-org-app
#
resource "ibm_cr_namespace" "namespace" {
  name              = "ns-${var.org}-${var.app}"
  resource_group_id = ibm_resource_group.resource_group.id
}

#
# VPC for an environment : vpc-org-env
#
resource "ibm_is_vpc" "vpc-infra-ibm" {
  name = "vpc-${var.org}-${var.env}"
  resource_group = ibm_resource_group.resource_group.id
}


#
# Subnets for an environment : subnet-org-env
#
resource "ibm_is_subnet" "subnet" {
  name                     = "subnet-${var.org}-${var.env}"
  vpc                      = ibm_is_vpc.vpc-infra-ibm.id
  zone                     = var.vpc_zone
  total_ipv4_address_count = 256
}


#
# VPC Cluster for an application in an environment : "k8s-vpc-cluster-org-app-env
# 
resource "ibm_container_vpc_cluster" "cluster" {
  name              = "k8s-vpc-cluster-${var.org}-${var.app}-${var.env}"
  vpc_id            = ibm_is_vpc.vpc-infra-ibm.id
  resource_group_id = ibm_resource_group.resource_group.id
  kube_version      = var.kube_version
  flavor            = var.machine_type
  worker_count      = 1
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = var.vpc_zone
  }
}


#
# Worker pool wp-${var.org}-${var.app}-${var.env}
#   a 2nd worker pool with a 2nd subnet would be needed to create a multizone cluster
#
resource "ibm_container_vpc_worker_pool" "cluster_pool" {
  cluster           = ibm_container_vpc_cluster.cluster.id
  worker_pool_name  = "wp-${var.org}-${var.app}-${var.env}"
  flavor            = var.machine_type
  vpc_id            = ibm_is_vpc.vpc-infra-ibm.id
  worker_count      = var.poolsize
  resource_group_id = ibm_resource_group.resource_group.id
  zones {
    name      = var.vpc_zone
    subnet_id = ibm_is_subnet.subnet.id
  }
}


#
# COS Instance cos-instance-org-app-env
#
resource "ibm_resource_instance" "cos_instance" {
	name 				= "cos-instance-${var.org}-${var.app}-${var.env}"
	resource_group_id 	= ibm_resource_group.resource_group.id
	service           	= "cloud-object-storage"
	plan              	= "standard"
	location          	= "global"
}


#
# COS Bucket cos-bucket-org-app-env
#
resource "ibm_cos_bucket" "cos_bucket" {
	bucket_name 			= "cos-bucket-${var.org}-${var.app}-${var.env}"
	resource_instance_id 	= ibm_resource_instance.cos_instance.id
	region_location 		= var.region
	storage_class 			= "standard"
}
