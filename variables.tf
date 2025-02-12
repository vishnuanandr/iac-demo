variable "instance_name1" {
  description = "First AWS Instance Name"
  type        = string
  default     = "My_1st_Instance"
}

variable "Environment" {
  description = "Describes the environment name"
  type        = string
  default     = "Test"
}


variable "sources" {
  type    = string
  default = "Terraform"
}
