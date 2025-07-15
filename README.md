# hcloud_fcos_takeover
*Terraform module that outputs user_data for a Hetzner Cloud VPS to install Fedora CoreOS with a given Butane config*

There won't be much documentation here. Currently, this is only a PoC. If you are interested and need help to understand something in this module, feel free to reach out to me 😀.

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
  source = "git::https://github.com/tmsmr/hcloud_fcos_takeover.git?ref=v0.2.0"

  butane_config            = file("config.butane")
}

resource "hcloud_server" "fcos_server" {
  name        = "fcos"
  image       = "fedora-42"
  server_type = "cx22" # at least 4 GB memory

  user_data = module.hcloud_fcos_takeover.user_data
}
```
- Wait a couple of minutes

## Variables
Besides `butane_config`, you might want to set the following variables:
- `authorized_key_bootstrap`: 
- `install_device` (defaults to `/dev/sda`)
- `hcloud_console` (defaults to `ttyS0`)
- `pre_takeover`: Shell command to run before the takeover script is executed
- `post_takeover`: Shell command to run after the takeover script is executed

## Limitations
- The Ignition config is generated using [poseidon/terraform-provider-ct](https://github.com/poseidon/terraform-provider-ct). Currently, the latest supported Butane version is `1.5.0`.
- Fedora CoreOS is installed using `kexec` after loading a modified live image to the main memory. As a result, you need a machine type with at least 4 GB of memory.
- The `image` for `hcloud_server` has to be Fedora, since [takeover.sh](./tpl/takeover.sh) expects Fedora-specific tooling.

## Disclaimer
Check *LICENSE* for details. If this tool eats your dog, it's not my fault.
