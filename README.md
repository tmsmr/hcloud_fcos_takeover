# hcloud_fcos_takeover
*Terraform module that outputs user_data for a Hetzner Cloud VPS to install Fedora CoreOS with a given Butane config*

There won't be much documentation here. Currently this is only a PoC. If you are interested and need help to understand something in this module, feel free to reach out to me 😀.

## Quick start
- Have a [Butane config](https://coreos.github.io/butane/) available
```bash
$ cat config.butane 
variant: fcos
version: 1.5.0
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - ssh-rsa AAA...
```
- Use the module and supply the `user_data` to a `hcloud_server`
```hcl
module "hcloud_fcos_takeover" {
  source = "git::https://github.com/tmsmr/hcloud_fcos_takeover.git?ref=v0.1.0"

  butane_config            = file("config.butane")
  authorized_key_installer = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "fcos_server" {
  name        = "fcos"
  image       = "fedora-42"
  server_type = "cx22"
  public_net {
    ipv4_enabled = true
  }
  user_data = module.hcloud-fcos-takeover.user_data
}
```
- Wait a couple of minutes

## Limitations
- Fedora CoreOS is installed using `kexec` after loading a modified live image to the main memory. As a result, you need a machine type with at least 4 GB of memory.
- The `image` for `hcloud_server` has to be Fedora, since the installer expects that.

## Disclaimer
Check *LICENSE* for details. If this tool eats your dog, it's not my fault.
