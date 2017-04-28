# terraform
we will be creating a basic AWS VPC resources including the following:

VPC
Subnets (one private and two private)
Routes
Route Tables
Elastic (EIP)
Nat Gateway
Route Association Table

# Let’s get-started

-AWS VPC stands for Virtual Private Cloud which basically provides a way to structure your own network the way you want in AWS. Before we dive in let’s define some basic VPC concepts:

-CIDR – Classless Intern-Domain Routing, let’s choose the address range which will represent our VPC (172.31.0.0/16)  which in turn gives the following in the binary format 1010 1100.1111 0000.0000 0000.0000 0000  the slash 16 (/16) indicates the first 16 bits will be fixed and represents the network and the rest 16 bits will represent the hosts. I will recommend to use the /16 which will have 64 000 IP addresses which is nice for some use cases.
 
-Subnets: In this tutorial we will setup three subnets, one public (  172.31.0.0/24 ) and two privates ( 172.31.1.0/24 and 172.31.2.0/24 ), what this means is that the public subnet can be accessible from the internet and the private subnets cannot be accessible from the internet. Each subnet will have 251 IP addresses. 

Internet Gateway: An Internet Gateway is a VPC component that allows communication between your VPC and the internet. 

-Nat Gateway: Network Address Translation Gateway is used to allow the instances in the private subnets to connect to the internet but the other way around is not possible for example it will prevent the internet from initiating a connection with the instances in the private subnets. 

-Route Table: The route table basically contains rules regarding where the packets should go, in our case we will have two route tables, one for the public subnet in which all connections to the internet will go through the Internet Gateway and as for the private subnets all connections to the internet will go through the NAT Gateway. 

-Elastic EIP: An EIP will be asssociated with the NAT Gateway, so basically an elastic IP is a static IP associated with your AWS account, for example you can use an EIP for an instance with private IP so that the instance will be reachable from the internet. 

-Route Association Table: This means you can associate your subnets to the route tables you’ve defined, therefore the rules defined in that route table will be applied to the subnets.

# Configure AWS Provider

-provider: Represents in Terraform HCL language the cloud provider which can be AWS (Amazon Web Services), GCP (Google Cloud Platform), Azure and so on. Check out the list of all supported providers https://www.terraform.io/docs/providers/index.html

-region: Represents the aws geographical location where your resources will be created and in my case the location is Ireland in Europe. And more on AWS region, checkout this out http://aws.amazon.com/about-aws/global-infrastructure/

-access_key: Your AWS user account access_key, will be used by Terraform to perform some task on your AWS account on your behalf 

-secret_key: Your AWS user account secret_key, will be used by Terraform to perform some task on your AWS account on your behalf 

# Create VPV

-resources: is a Terraform HCL notation for creating resources 

-aws_vpc: Terraform notation representing AWS VPC resource 

-vpc_tuto: is a name given to the VPC which can be used later to get thing like vpc_id or main_route_table_id

-cidr_block: Address range for the VPC 

-enable_dns_support: If set to true will enable DNS support to the VPC, so this will indicate that the DNS resolution will be  supported for the VPC

-enable_dns_hostname: Indicates whether the instances launched in the VPC get DNS hostnames. 

-tags: Tags are helpful, when you want to categorize your resources. 


# Create VPC Pub Subnet

-aws_subnet: Terraform notation representing AWS VPC subnet resource

-public_subnet_eu_west_1a: Name given the subnet

- map_public_ip_on_launch: Means that any instance created in this subnet will have a public IP

-vpc_id: VPC ID, is actually the VPC we’ve created above

- availability_zone: As mentioned, the resources will be created in the Ireland region and within the region you have multiple availability zone which represents a physical isolated datacenter.

-aws_internet_gateway: Terraform notation for creating an Internet Gateway resource in AWS 



# More terms
-aws_route: Terraform notation for creating an Route resource in AWS 

-internet_access: Name given to the route 

-route_table_id: Route table ID which contains rules indicating how the packets should be routed, we will assign the main vpc route table ID, in AWS when you created a VPC, you will have a main route table by default

-destination_cidr_block: The destination which obviously here is the internet

-gateway_id: Gateway ID, where all the packets to the internet should be routed through, if you remember the Internet Gateway allow you VPC to communicate with the Internet.


-aws_eip: Terraform notation for creating an EIP resource in AWS 

-vpc: If true, the EIP is in the VPC 

-depend_on: Conditional variable which say in this case the EIP resource should be created after the Internet Gateway is already created


-aws_nat_gateway: Terraform notation for creating an NAT Gateway resource in AWS 

-nat: Name given to the NAT resource 

-allocation_id: The NAT should have an elastic IP address (static IP) 

-subnet_id: Subnet ID in which the NAT resource will be created 


