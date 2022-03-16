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

#resource "ibm_is_subnet" "subnet2" {
#  name                     = "mysubnet2"
#  vpc                      = ibm_is_vpc.vpc1.id
#  zone                     = "us-south-2"
#  total_ipv4_address_count = 256
#}


#
# VPC Cluster for an application in an environment : "k8s-vpc-cluster-org-app-env
# 
resource "ibm_container_vpc_cluster" "cluster" {
  name              = "k8s-vpc-cluster-${var.org}-${var.app}-${var.env}"
  vpc_id            = ibm_is_vpc.vpc-infra-ibm.id
  flavor            = var.machine_type
  worker_count      = 3
  resource_group_id = ibm_resource_group.resource_group.id
  kube_version      = var.kube_version
  zones {
    subnet_id = ibm_is_subnet.subnet.id
    name      = var.vpc_zone
  }
}


#
# Worker pool wp-${var.org}-${var.app}-${var.env}
#   a 2nd worker pool with a 2nd subnet would be needed to create a multisonz cluster 
#
resource "ibm_container_vpc_worker_pool" "cluster_pool" {
  cluster           = ibm_container_vpc_cluster.cluster.id
  worker_pool_name  = "wp-${var.org}-${var.app}-${var.env}"
  flavor            = var.machine_type
  vpc_id            = ibm_is_vpc.vpc-infra-ibm.id
  worker_count      = 3
  resource_group_id = ibm_resource_group.resource_group.id
  zones {
    name      = var.vpc_zone
    subnet_id = ibm_is_subnet.subnet.id
  }
}


#
# K8s Cluster on classic infrastructure 
#
#resource "ibm_container_cluster" "k8s-cluster-infra-ibm" {
#  name              = "k8s-classic-cluster-${var.org}-${var.app}-${var.env}"
#  datacenter        = var.datacenter
#  hardware          = var.hardware
#  default_pool_size = var.poolsize
#  machine_type      = var.machine_type
#  public_vlan_id    = var.public_vlan_id
#  private_vlan_id   = var.private_vlan_id
#  kube_version      = var.kube_version
#}


# data "ibm_org" "org" {
#   org = "${var.ibm_org}"
# }

# data "ibm_space" "space" {
#   org   = "${var.ibm_org}"
#   space = "${var.space}"
# }

# resource "ibm_service_instance" "mysql_db" {
#   name       = "${var.service_name}"
#   space_guid = "${data.ibm_space.space.id}"
#   service    = "compose-for-mysql"
#   plan       = "Standard"
# }

# resource "ibm_service_key" "mysql_db_key" {
#   name                  = "db_key"
#   service_instance_guid = "${ibm_service_instance.mysql_db.id}"
# }

# resource "ibm_container_bind_service" "bind_service" {
#   cluster_name_id     = "${ibm_container_cluster.cluster.id}"
#   service_instance_id = "${ibm_service_instance.mysql_db.id}"
#   namespace_id        = "default"
# }
