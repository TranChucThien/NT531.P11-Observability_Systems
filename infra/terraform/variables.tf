# variable "access_key" {
#   description = "AWS Access Key"
#   type = string
# }

# variable "secret_key" {
#   description = "value"
#   type = string
# }

# variable "token" {
#   description = "value"
#   type = string
# }

variable "iam_role_arn" {
  description = "value"
  default = "arn:aws:iam::268005715929:role/LabRole"
}

variable "vpc_id" {
  description = "value"
  default = "vpc-0569fc86779a785f7"
}

