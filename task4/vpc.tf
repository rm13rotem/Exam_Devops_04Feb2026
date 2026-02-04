
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
}


# 1. הוספת המקור שמושך את רשימת ה-Zones הזמינים ב-Region שלך
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "Public_Subnet" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.example.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = var.if_public_ip

  # 2. התיקון הקריטי: כל סאבנט יקבל Zone אחר (למשל us-east-1a ואז us-east-1b)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.Public_Subnet[count.index].id
  route_table_id = aws_route_table.rt_public.id
}
