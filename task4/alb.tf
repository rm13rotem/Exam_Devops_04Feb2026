resource "aws_launch_template" "my_tpl" {
  name_prefix   = "rotem-tpl-"
  image_id      = "ami-0c398cb65a93047f2"
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = var.if_public_ip
    security_groups             = [aws_security_group.sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              echo "<h1>Hello from ASG</h1>" > /var/www/html/index.html
              EOF
  )
}

resource "aws_lb" "alb_rotem" {
  name               = "alb-rotem" 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = aws_subnet.Public_Subnet[*].id
}

resource "aws_lb_target_group" "my_tg" {
  name     = "rotem-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_rotem.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_autoscaling_group" "my_asg" {
  vpc_zone_identifier = aws_subnet.Public_Subnet[*].id
  target_group_arns   = [aws_lb_target_group.my_tg.arn]
  min_size            = 1
  max_size            = 3
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.my_tpl.id
    version = "$Latest"
  }
}