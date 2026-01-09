module "db" {
  source = "../"

  myIdentifier = "my-db"

  sqlEngine            = "mysql"
  engineVersn    = "8.0"
  instance_type    = "db.t3.micro"
  dbStorage = 5

  my_db_name  = "Mydatabase"
  dbUserName = "user"
  myport     = "3306"
  dbPasswd = "dfsfsfsewfe"

#   iam_database_authentication_enabled = true

  custsg = "sg-02e7e683648eb8441"

  my_maintenance_window = "Mon:00:00-Mon:03:00"
  my_backup_retention_prd =  "7"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
#   my_monitoring_interval    = "30"
#   monitoring_role_name   = "MyRDSMonitoringRole"
#   create_monitoring_role = true

  # DB subnet group
  
  my_subnet_grp_name = "mysubnetgroup"
   # DB parameter group
#   family = "mysql8.0"

  # DB option group
#   major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_permission = true

#   parameters = [
#     {
#       name  = "character_set_client"
#       value = "utf8mb4"
#     },
#     {
#       name  = "character_set_server"
#       value = "utf8mb4"
#     }
#   ]

#   options = [
#     {
#       option_name = "MARIADB_AUDIT_PLUGIN"

#       option_settings = [
#         {
#           name  = "SERVER_AUDIT_EVENTS"
#           value = "CONNECT"
#         },
#         {
#           name  = "SERVER_AUDIT_FILE_ROTATIONS"
#           value = "37"
#         },
#       ]
#     },
#   ]
}