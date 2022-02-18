Here we create a local module with the name aws_base  
This module contains,  
1. 1 VPC (myvpc)  
2. 2 Subnets (1 public,1 private)  
3. Routing table (rt)  
4. Internet gateway (igw)  

Here in the module, we are not adding nat gateway.  

In the module mainly 3 file are there with name main, output, & version. 

referance https://registry.terraform.io/providers/hashicorp/aws/2.34.0/docs/guides/eks-getting-started
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
https://antonputra.com/terraform/how-to-create-eks-cluster-using-terraform/#create-eks-cluster-using-terraform

aws eks --region ap-south-1 update-kubeconfig --name my_eks
