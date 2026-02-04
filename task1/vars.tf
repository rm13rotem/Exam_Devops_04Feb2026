variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnet_count" {}
variable "instance_type" {}
variable "if_public_ip" {
  type = bool
}