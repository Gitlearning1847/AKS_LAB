variable "user_node" {
  type = string
}


variable "zones" {
  type = list(string)
}

variable "mode" {
  type = string
}

variable "AKS_ID" {
  type = string
}

variable "tags" {
  type = map(string)
}
