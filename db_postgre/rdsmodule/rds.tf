resource "aws_db_instance" "RDSpostgre" {
  identifier              = var.env_identifier
  instance_class          = var.instance_class
  engine_version          = var.engine_version
  engine                  = var.engine
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  password                = aws_ssm_parameter.db_password_parameter.value
  username                = aws_ssm_parameter.db_username_parameter.value
  vpc_security_group_ids  = [aws_security_group.rds_db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.centos_db_subnet_group.name
  parameter_group_name    = "postgres"
  skip_final_snapshot     = true
  maintenance_window      = var.maintenance
  backup_window           = var.backup
  backup_retention_period = var.backup_retention
  multi_az                = true
  publicly_accessible     = false
}


#subnet group
resource "aws_db_subnet_group" "centos_db_subnet_group" {
  name        = "centos_db_subnet_group"
  description = "db subnet group"
  subnet_ids  = [var.subnet_id1, var.subnet_id2]
}

#DB security group

resource "aws_security_group" "rds_db_sg" {
  name        = "rds_db_sg"
  description = "sg for database"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow postgre traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.cidr_blocks]
  }

  egress {
    description = "something"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.cidr_blocks]
  }


}

resource "random_string" "db_username" {
  length = 10
  special = false
}

resource "random_string" "db_password" {
  length  = 20
  special = false
}

resource "aws_ssm_parameter" "db_username_parameter" {
  name  = "dbpostgre"
  type  = "SecureString"
  value = random_string.db_username.result
}

resource "aws_ssm_parameter" "db_password_parameter" {
  name  = "dbpostgre"
  type  = "SecureString"
  value = random_string.db_password.result
}