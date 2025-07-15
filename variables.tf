variable "butane_config" {
  type = string
}

variable "authorized_key_bootstrap" {
  type    = string
  default = ""
}

variable "install_device" {
  type    = string
  default = "/dev/sda"
}

variable "hcloud_console" {
  type    = string
  default = "ttyS0"
}

variable "pre_takeover" {
  type    = string
  default = ""
}

variable "post_takeover" {
  type    = string
  default = ""
}
