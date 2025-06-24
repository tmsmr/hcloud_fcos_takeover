data "ct_config" "fcos_config" {
  content      = var.butane_config
  strict       = true
  pretty_print = true
}

locals {
  takeover_script = templatefile(
    "${path.module}/tpl/takeover.sh",
    {
      ignition_config_path = "/config.ign",
      install_device       = "/dev/sda"
    }
  )

  user_data = templatefile(
    "${path.module}/tpl/user_data.yaml",
    {
      authorized_key  = var.authorized_key_installer
      ignition_config = indent(6, data.ct_config.fcos_config.rendered)
      takeover_script = indent(6, local.takeover_script)
    }
  )
}
