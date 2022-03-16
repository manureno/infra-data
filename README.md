# ibmcloud-terraform


create a K8S cluster in a single zone in a VPC

based on sample : https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/container_vpc_cluster


ibmcloud CLI  cheat sheet:

List available zones 
ibmcloud ks locations

List avaialble machines flavors : ibmcloud ks flavors --zone 
Ex for VPC zone eu-de-1 : machine bx2.2x8
Ex for classic zone fra02 : machine b3c.4x16