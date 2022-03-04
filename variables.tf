variable "ibmcloud_api_key" {
    description = "Your IBM Cloud IAM key to provision resources. Create an IBM Cloud IAM key here: cloud.ibm.com/iam/apikeys"
}

# variable "org" {
#     description = "Your IBM Cloud organization which is gnerally your email address. Run `ibmcloud cf orgs` to see all your orgs."
#  }

# variable "space" {
#     description = "Your IBM Cloud space to provision the Compose for MySQL service. Run `ibmcloud cf spaces` to see all your spaces."
# }

variable "region" {
     default = "eu-central"
     description = "Region to provision resources (eu-central = France!)."
}

variable "datacenter" {
    default = "par01"
    description = "The datacenter to provision your resources in IBM Cloud (default is Paris)."
}

variable "machine_type" {
    default = "bx2.2x8"
    description = "The flavor of worker node in your cluster. Run `ibmcloud ks flavors --zone <datacenter>` to see the different flavors."
}

variable "private_vlan_id" {
    description = "Your private VLAN ID. If you don't have one, set this value to 'null' and one will be created for you. Run `ic ks vlans --zone <datacenter>` to see your VLANs."
 }

variable "public_vlan_id" { 
    description = "Your private VLAN ID. If you don't have one, set this value to 'null' and one will be created for you. Run `ic ks vlans --zone <datacenter>` to see your VLANs."
}

variable "cluster_name" {
    default = "k8s-cluster"
    description = "Name of your Kubernetes or OpenShift cluster."
}

variable "poolsize" {
    type = number
    default = 2
    description = "Number of nodes in your cluster."
}

# variable "service_name" {
#     default = "composeformysql"
#     description = "Service ID for the Compose for MySQL instance."
#  }

 variable "kube_version" {
    default = "1.14.7"
    description = "Version of Kubernetes or OpenShift. Run `ic ks versions` to see all the versions."
 }
 variable "hardware" {
    default = "shared"
    description = "Type of hardware for Kubernetes or OpenShift cluster."
 }
