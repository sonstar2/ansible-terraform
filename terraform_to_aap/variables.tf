variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "subnet_id" {
  type    = string
  default = "subnet-008978c379e91949f"
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-0eeace75c41364e06"]
}


variable "win_2019_full_ami_id" {
  type    = string
  default = "ami-051cf2e90cf9c0365"
}

variable "win_2019_core_ami_id" {
  type    = string
  default = "ami-01804061362f088d7"
}