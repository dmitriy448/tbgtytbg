variable "vpc_id" {
  type = string
}

variable "cidr_blocks" {
  type = string
}

variable "env_identifier" {
  type = string
}
variable "engine_version" {
  type = string
}

variable "engine" {
  type = string
}


variable "db_name" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "db_username" {
  type = string
}

variable "allocated_storage" {
  type = string
}

variable "parameter_group_name" {
  type = string
}
variable "region" {
  type = string
}

variable "maintenance" {
  type = string
}

variable "backup" {
  type = string
}

variable "data" {
  type = string
}

variable "backup_retention" {
  type = string
}

variable "subnet_id1" {
  type = string
}

variable "subnet_id2" {
  type = string
}