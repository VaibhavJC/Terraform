
resource "aws_db_instance" "my-db" {
  instance_class = var.instance_type
  engine = var.sqlEngine
  engine_version = var.engineVersn
  identifier = var.myIdentifier
  username = var.dbUserName
  password = var.dbPasswd
  vpc_security_group_ids = [var.custsg]
  allocated_storage = var.dbStorage
  port = var.myport
  maintenance_window = var.my_maintenance_window
  backup_retention_period = var.my_backup_retention_prd
  db_subnet_group_name = var.my_subnet_grp_name
  db_name = var.my_db_name
  deletion_protection = var.deletion_permission
  
}