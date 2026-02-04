# create vpc 
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr

  
}

# create the subnet and connect to vpc
resource "aws_subnet" "Public-Subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = var.if_public_ip
}
resource "aws_subnet" "Private-Subnet" {
  vpc_id                  = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
}

# create igw and connect to vpc
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "rotem-igw"
  }
}
# create a route table -Public
resource "aws_route_table" "rt_Public" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
# create a route table -Private
resource "aws_route_table" "rt_Private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "con-Public-rt" {
  subnet_id      = aws_subnet.Public-Subnet.id 
  route_table_id = aws_route_table.rt_Public.id
}

# connect the route table to the subnet
resource "aws_route_table_association" "con-Private-rt" {
  subnet_id      = aws_subnet.Private-Subnet.id 
  route_table_id = aws_route_table.rt_Private.id
}
