variable "org" {
	description = "Name of the organization to which belong this infrastructure"
	type = string
	default = "org"
}

variable "app" {
	description = "Name of the application using that uses this infrastructure"
	type = string
	default = "app"
}

variable "env" {
	description = "Name of the environment for which is used this infrastrutreu (ex: dev/int/uat/etc.)"
	type = string
	default = "dev"
}

variable "ibmcloud_api_key" {
    description = "Your IBM Cloud IAM key to provision resources. Create an IBM Cloud IAM key here: cloud.ibm.com/iam/apikeys"
}

variable "region" {
     default = "eu-de"
     description = "Region to provision resources."
}

variable "vpc_zone" {
     default = "eu-de-1"
     description = "VPC Zone to provision resources. Run ibmcloud ks locations to list availables zones"
}

variable "datacenter" {
    default = "fra02"
    description = "The datacenter (seem a synonym of classic zone) to provision your resources in IBM Cloud."
}

variable "machine_type" {
    default = "free"
    description = "The flavor of worker node in your cluster. Run `ibmcloud ks flavors --zone <datacenter>` to see the different flavors."
}

variable "poolsize" {
    type = number
    default = 1
    description = "Number of nodes in your cluster."
}

 variable "kube_version" {
    default = "1.22.7"
    description = "Version of Kubernetes or OpenShift. Run `ic ks versions` to see all the versions."
 }
 variable "hardware" {
    default = "shared"
    description = "Type of hardware for Kubernetes or OpenShift cluster."
 }
