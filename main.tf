# Create a VPC 
resource "aws_vpc" "vpc_tuto" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "TestVPC"
  }
}
# Create VPC public subnet
resource "aws_subnet" "public_subnet_us-east-1a" {
  vpc_id                  = "${aws_vpc.vpc_tuto.id}"
  cidr_block              = "172.31.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
  	Name =  "Subnet az 1a"
  }
}

# Create VPC private subnets
resource "aws_subnet" "private_1_subnet_us-east-1a" {
  vpc_id                  = "${aws_vpc.vpc_tuto.id}"
  cidr_block              = "172.31.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
  	Name =  "Subnet private 1 az 1a"
  }
}

# Create VPC private subnets (2)  
resource "aws_subnet" "private_2_subnet_us-east-1a" {
  vpc_id                  = "${aws_vpc.vpc_tuto.id}"
  cidr_block              = "172.31.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
  	Name =  "Subnet private 2 az 1a"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_tuto.id}"
  tags {
        Name = "InternetGateway"
    }
}

# Create route to the internet
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc_tuto.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

# Create Elastic IP (EIP)
resource "aws_eip" "tuto_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

# Create NAT Gateway 
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.tuto_eip.id}"
    subnet_id = "${aws_subnet.public_subnet_us-east-1a.id}"
    depends_on = ["aws_internet_gateway.gw"]
}

# Create private route table and the route to the internet 
resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.vpc_tuto.id}"
 
    tags {
        Name = "Private route table"
    }
}
 
resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}
# Create Route Table Associations 
# Associate subnet public_subnet_us-east-1a to public route table
resource "aws_route_table_association" "public_subnet_us-east-1a_association" {
    subnet_id = "${aws_subnet.public_subnet_us-east-1a.id}"
    route_table_id = "${aws_vpc.vpc_tuto.main_route_table_id}"
}
 
# Associate subnet private_1_subnet_us-east-1a to private route table
resource "aws_route_table_association" "pr_1_subnet_us-east-1a_association" {
    subnet_id = "${aws_subnet.private_1_subnet_us-east-1a.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}
 
# Associate subnet private_2_subnet_us-east-1a to private route table
resource "aws_route_table_association" "pr_2_subnet_us-east-1a_association" {
    subnet_id = "${aws_subnet.private_2_subnet_us-east-1a.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}
