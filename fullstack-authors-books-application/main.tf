resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Project-FullStack"
  }
}

resource "aws_subnet" "pub-subnet-A" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Pub-Subnet-A"
  }
}

resource "aws_subnet" "pub-subnet-B" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub-Subnet-B"
  }
}

resource "aws_subnet" "frontend-A" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PVT-Frontend-A"
  }
}

resource "aws_subnet" "frontend-B" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PVT-Frontend-B"
  }
}

resource "aws_subnet" "backend-A" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PVT-Backend-A"
  }
}

resource "aws_subnet" "backend-B" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PVT-Backend-B"
  }
}

resource "aws_subnet" "RDS-A" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PVT-RDS-A"
  }
}

resource "aws_subnet" "RDS-B" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1b"
  cidr_block              = "10.0.7.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "PVT-RDS-B"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Project-IGW"
  }
}

resource "aws_route_table" "PUB-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

#Pub-Subnet association start

resource "aws_route_table_association" "Pub-Subnet-Association-A" {
  route_table_id = aws_route_table.PUB-RT.id
  subnet_id      = aws_subnet.pub-subnet-A.id
}

resource "aws_route_table_association" "Pub-Subnet-Association-B" {
  route_table_id = aws_route_table.PUB-RT.id
  subnet_id      = aws_subnet.pub-subnet-B.id
}

#PVT-Subnet association end

#Nat creation
resource "aws_eip" "nat-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "NAT-IG" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.pub-subnet-A.id

  tags = {
    Name = "Nat-IGW"
  }
}

#PVT-RT creation
resource "aws_route_table" "PVT-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT-IG.id
  }

  tags = {
    Name = "PVT-RT"
  }
}

#PVT-RT - subnet association
resource "aws_route_table_association" "frontend-association-A" {
  subnet_id      = aws_subnet.frontend-A.id
  route_table_id = aws_route_table.PVT-RT.id
}

resource "aws_route_table_association" "frontend-association-B" {
  subnet_id      = aws_subnet.frontend-B.id
  route_table_id = aws_route_table.PVT-RT.id
}

resource "aws_route_table_association" "backend-association-A" {
  subnet_id      = aws_subnet.backend-A.id
  route_table_id = aws_route_table.PVT-RT.id
}

resource "aws_route_table_association" "backend-association-B" {
  subnet_id      = aws_subnet.backend-B.id
  route_table_id = aws_route_table.PVT-RT.id

}

#Security Group

# variable "allowed_ports" {
#     type = map(string)
#     default = {
#         22 = "0.0.0.0/0"
#         80 = "0.0.0.0/0"
#         443 = "0.0.0.0/0"
#         3306 = "0.0.0.0/0"
#     }
# }

# resource "aws_security_group" "Cust-SG" {
#     vpc_id = aws_vpc.main.id
#     description = "Allow ssh"
#     name = "ProjectSG"
#     dynamic "ingress" {
#       for_each = var.allowed_ports
#       content {
#          description = "Allow ${ingress.key}"
#             from_port = ingress.key
#             to_port = ingress.key
#             protocol = "tcp"
#             cidr_blocks =  [ingress.value]
#       }
#     }

#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = {
#       Name = "Project-SG"
#     }
# }

#bastion-sg creation

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group" "bastion_SG" {
  name        = "Bastion-SG"
  vpc_id      = aws_vpc.main.id
  description = "Allow ssh myip"

}

resource "aws_vpc_security_group_ingress_rule" "bastion_ingress_rule" {
  security_group_id = aws_security_group.bastion_SG.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "${chomp(data.http.my_ip.response_body)}/32"
}

resource "aws_security_group_rule" "bastion-egress" {
  security_group_id = aws_security_group.bastion_SG.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
}
#frontend-sg creation

resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow bastion and http as well as https"
  depends_on  = [aws_security_group.external_lb_sg]
   
}

resource "aws_vpc_security_group_ingress_rule" "ssh_frontend_sg" {
  security_group_id = aws_security_group.frontend_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/24" #pub-subnet-cidr
}

resource "aws_security_group_rule" "frontend_sg" {
  type                     = "ingress"
  security_group_id        = aws_security_group.frontend_sg.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.external_lb_sg.id
  depends_on               = [aws_security_group.external_lb_sg, aws_security_group.frontend_sg]
}

resource "aws_security_group_rule" "frontend_sg_egress" {
  type              = "egress"
  security_group_id = aws_security_group.frontend_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "external_lb_sg" {
  name        = "External_LB_SG"
  description = "allow HTTP and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress = [
    for port in [443, 80] : {
      description      = "allow http and https"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# internal-alb-sg creation

resource "aws_security_group" "internal_alb_sg" {
  name        = "internal_alb_sg"
  description = "allow frontend traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "internal_alb_sg_ingress" {
  security_group_id        = aws_security_group.internal_alb_sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.frontend_sg.id
}

resource "aws_security_group_rule" "internal_alb_sg_egress" {
  security_group_id = aws_security_group.internal_alb_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# backend-sg creation

resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "allow internal-alb and frontend subnet cidr"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "backend_sg_ingress_rule_http" {
  security_group_id        = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.internal_alb_sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "backend_sg_ingress_rule_ssh" {
  security_group_id = aws_security_group.backend_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["10.0.2.0/24"]
  protocol          = "tcp"
}

resource "aws_security_group_rule" "backend_sg_egress_rule" {
  security_group_id = aws_security_group.backend_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# RDS-SG Creation

resource "aws_security_group" "RDS_sg" {
  name        = "RDS_sg"
  description = "Allow backend mysql request"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "RDS_sg_ingress_rule" {
  security_group_id        = aws_security_group.RDS_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend_sg.id
}

resource "aws_security_group_rule" "RDS_sg_egress_rule" {
  security_group_id = aws_security_group.RDS_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

#creating key-pair

resource "aws_key_pair" "ssh_public_key" {
  key_name   = "new_key"
  public_key = file("~/.ssh/new_key.pub")

}

#Instance Creation

resource "aws_instance" "Bastion" {
  ami                    = "ami-00ca570c1b6d79f36"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub-subnet-A.id
  key_name               = aws_key_pair.ssh_public_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_SG.id]
  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "frontend-instance" {
  ami                    = "ami-00ca570c1b6d79f36"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.frontend-A.id
  key_name               = aws_key_pair.ssh_public_key.key_name
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  
  tags = {
    Name = "Frontend"
  }
}

resource "aws_instance" "backend-instance" {
  ami                    = "ami-00ca570c1b6d79f36"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.backend-A.id
  key_name               = aws_key_pair.ssh_public_key.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  tags = {
    Name = "Backend"
  }
}

resource "aws_db_subnet_group" "RDS-subnet-group" {
  name       = "rdscustsubnetgrp"
  subnet_ids = [aws_subnet.RDS-A.id, aws_subnet.RDS-B.id]
  tags = {
    Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "RDS" {
  identifier              = "projectdb"
  db_name                 = "mydb"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = "admin"
  password                = "admin123"
  db_subnet_group_name    = aws_db_subnet_group.RDS-subnet-group.id
  parameter_group_name    = "default.mysql8.0"
  availability_zone       = "ap-south-1a"
  backup_retention_period = 1
  backup_window           = "02:00-03:00"
  maintenance_window      = "sun:04:00-sun:05:00"
  vpc_security_group_ids  = [aws_security_group.RDS_sg.id]
  deletion_protection     = false
  apply_immediately       = true
  skip_final_snapshot     = true
}

#TG and LB creation for backend

resource "aws_lb_target_group" "Backend-TG" {
  name     = "Backend-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/api/books"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "Backend-TG"
  }
}

resource "aws_lb_target_group_attachment" "backend-TG-attachment" {
  target_group_arn = aws_lb_target_group.Backend-TG.arn
  target_id        = aws_instance.backend-instance.id
  port = 80
}

resource "aws_lb" "Internal-LB" {
  name               = "ALB-Internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.internal_alb_sg.id]
  subnets            = [aws_subnet.backend-A.id, aws_subnet.backend-B.id]

  enable_deletion_protection = false

  tags = {
    Name = "ALB-Internal"
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.Internal-LB.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.Backend-TG.arn
    type             = "forward"
  }
}

# #TG and LB creation for frontend

resource "aws_lb_target_group" "frontend-tg" {
  name     = "frontend-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "frontend-TG"
  }
}

resource "aws_lb_target_group_attachment" "frontend-tg-attachment" {
  target_group_arn = aws_lb_target_group.frontend-tg.id
  target_id        = aws_instance.frontend-instance.id
}

resource "aws_lb" "external-LB" {
  name               = "ALB-External"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.external_lb_sg.id]
  subnets            = [aws_subnet.pub-subnet-A.id, aws_subnet.pub-subnet-B.id]

  enable_deletion_protection = false

  tags = {
    Name = "ALB-External"
  }
}

resource "aws_lb_listener" "external-lb-listener" {
  load_balancer_arn = aws_lb.external-LB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.frontend-tg.arn
    type             = "forward"
  }
}

# # frontend asg creation

data "aws_ami" "frontend_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["frontend-ami"]
  }
}

resource "aws_launch_template" "frontend_lt" {
  name                   = "frontend-lt"
  description            = "frontend-terraform"
  image_id               = data.aws_ami.frontend_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = aws_key_pair.ssh_public_key.id

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF
  )

  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "frontend-lt"
    }
  }
}

resource "aws_autoscaling_group" "frontend-asg" {
  name_prefix         = "frontend-asg"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.frontend-A.id, aws_subnet.frontend-B.id]
  target_group_arns   = [aws_lb_target_group.frontend-tg.arn]
  health_check_type   = "EC2"
  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = aws_launch_template.frontend_lt.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }

    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }
  tag {
    key                 = "Name"
    value               = "frontend-asg"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "frontend-dynamic-scaling-policy" {
  name = "frontend-cpu-target-tracking"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.frontend-asg.name
  estimated_instance_warmup = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 2
  }
}

# backend asg creation

data "aws_ami" "backend_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["backend-ami"]
  }
}

resource "aws_launch_template" "backend_lt" {
  name                   = "backend-lt"
  description            = "backend-terraform"
  image_id               = data.aws_ami.backend_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = aws_key_pair.ssh_public_key.id

  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-lt"
    }
  }
}

resource "aws_autoscaling_group" "backend-asg" {
  name_prefix         = "backend-asg"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.backend-A.id, aws_subnet.backend-B.id]
  target_group_arns   = [aws_lb_target_group.Backend-TG.id]
  health_check_type   = "EC2"
  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = aws_launch_template.backend_lt.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }

    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }
  tag {
    key                 = "Name"
    value               = "backend-asg"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "backend-dynamic-scaling-policy" {
  name = "backend-cpu-target-tracking"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend-asg.name 
  estimated_instance_warmup = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 2
  }
}