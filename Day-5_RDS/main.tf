resource "aws_vpc" "cust-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "cust-VPC"
    }
}

resource "aws_subnet" "pub-subnet"{
    vpc_id = aws_vpc.cust-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true

    tags = {
      Name = "Public_subnet"
    }
}

resource "aws_subnet" "pvt-subnet" {
    vpc_id = aws_vpc.cust-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "Pvt-Subnet-1"
    }
}

resource "aws_subnet" "pvt-subnet-1" {
    vpc_id = aws_vpc.cust-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
    tags = {
        Name = "Pvt-Subnet-2"
    }
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.cust-vpc.id

    tags = {
      Name = "IG"
    }

}

resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.cust-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IG.id
    }

    tags = {
      Name = "pub-rt"
    }

}

resource "aws_route_table_association" "pub-rt-association" {
    route_table_id = aws_route_table.pub-rt.id
    subnet_id = aws_subnet.pub-subnet.id
}

resource "aws_eip" "eip_for_nat-1" {
    domain = "vpc"
}

resource "aws_nat_gateway" "NAT-IG" {
  allocation_id = aws_eip.eip_for_nat-1.id
  subnet_id = aws_subnet.pub-subnet.id

  tags = {
    Name = "NAT-IG"
  }
}

resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.cust-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT-IG.id
  }

  tags = {
    Name = "NAT-IG"
  }
}

resource "aws_route_table_association" "pvt-sub-1-association" {
  subnet_id = aws_subnet.pvt-subnet.id
  route_table_id = aws_route_table.pvt-rt.id
}

resource "aws_route_table_association" "pvt-sub-2-association" {
  subnet_id = aws_subnet.pvt-subnet-1.id
  route_table_id = aws_route_table.pvt-rt.id
}

resource "aws_security_group" "rds-sg" {
    vpc_id = aws_vpc.cust-vpc.id
    name = "allow mysql"
    ingress {
        description = "allow mysql"
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "RDS-SG"
    }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
    name = "cust-subnet-group"
    subnet_ids = [aws_subnet.pvt-subnet.id, aws_subnet.pvt-subnet-1.id]

    tags = {
      Name = "Cust-rds-sg"
    }
}

resource "aws_db_instance" "default" {
    allocated_storage = 5
    instance_class = "db.t3.micro"
    db_name = "MyDatabase"
    engine = "mysql"
    identifier = "rds-db"
    engine_version = "8.0"
    username = "admin"
    password = "admin123"

    db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.id
    parameter_group_name = "default.mysql8.0"
   
    backup_retention_period  = 1
    backup_window            = "02:00-03:00" 
    
    maintenance_window = "sun:04:00-sun:05:00" 
    deletion_protection = false

    apply_immediately = true
    
    skip_final_snapshot = true

   
}
resource "aws_db_instance" "replica" {
    identifier = "rds-replica"
    instance_class = "db.t3.micro"
    engine = "mysql"
    
    replicate_source_db = aws_db_instance.default.arn

    db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
    
    vpc_security_group_ids = [aws_security_group.rds-sg.id]

    
}