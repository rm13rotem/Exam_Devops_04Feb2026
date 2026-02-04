#  create a security group
resource "aws_security_group" "sg" {
  name   = "sg_rotem"
  vpc_id = aws_vpc.example.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#instance.tf 
resource "aws_instance" "my_instance" {
  ami                    = "ami-0c398cb65a93047f2" 
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Public_Subnet[0].id
  associate_public_ip_address = var.if_public_ip
  vpc_security_group_ids = [aws_security_group.sg.id]
  
  tags = {

    Name = "rotem-ec2"
  }

  #depends_on = aws_subnet.Public_Subnet[]
}


output "public_id_ec2" {
  value = aws_instance.my_instance.public_ip
}