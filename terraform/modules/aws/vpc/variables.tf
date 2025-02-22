variable "availability_zones" {
  type    = list(string)
  default = ["10.1.0.0/16", "172.2.1.0/16"]
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.1.1.0/24", "172.1.1.0/24"]
}
