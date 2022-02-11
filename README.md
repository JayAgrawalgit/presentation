Hello All.
Given Tasklist
1. Create VPC, Subnet, routing table, internet gateway, and NAT using Terraform. 
2. Create EKS Cluster and worker nodes using Terraform. 
3. Connect the EKS cluster, Deploy the Jenkins server and agent on the EKS cluster. 
4. Push your WordPress and MySQL docker images on ECR. 
5. Create a Jenkins pipeline and deploy the WordPress and MySQL application using the Helm chart. 
6. Prepare end-to-end documentation.

## versions used: 
Terraform: v1.1.4 [on linux_amd64] 
AWS: aws-cli/1.18.69 (Python/3.8.10 Linux/5.13.0-27-generic botocore/1.16.19  --> can be ignorable)  
Kubernetes: v1.21  
Jenkins: 3.11.4  
WordPress: 5.9.0-apache  
MySQL: 5.6  
kube-proxy: 1.21.2  

Here we segregate this project's into folders i.e.  
### 1. Terraform:  
    The folder 'Terraform' stores mostly all .tf files containing the architecture of AWS. The structure is as below.  
Here we create a local module containing VPC, subnets [public & private], Internet gateway & Routing table resources for creating basic stature on AWS for deploying our Projects. After that, we create 3 more files with the name main, eks & nodes for other resources. (for more details you can refer to README in the same folder).  

### 2. Kubernetes:  
    The folder 'Kubernetes' stores all Helm charts which are used for deploying MySQL, WordPress & modified official's Jenkins helm chart.  
  
### 3. Jenkins:  

