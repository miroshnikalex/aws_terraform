variable "ANSIBLE_USER" {}
variable "ANSIBLE_PASSWORD_PLAIN" {}
variable "ANSIBLE_PASSWORD_HASH" {}
variable "AWS_REGION" {
  default = "eu-central-1"
}
variable "AWS_AMI" {
  type = "map"
  default = {
    eu-central-1 = "ami-d74be5b8"
    eu-west-1    = "ami-ebd02392"
    eu-west-2    = "ami-a1f5e4c5"
    ca-central-1 = "ami-9062d0f4"
    us-east-1    = "ami-c998b6b2"
  }
}
variable "AWS_KEY_NAME" {}
variable "AWS_INSTANCE_TYPE" {
  default = "t2.micro"
}
variable "AWS_PROFILE_NAME" {}
