data "template_file" "corefile" {
  template = "${ file( "${ path.module }/corefile" )}"
  vars {
    domain = ${ var.domain }
  }
}

data "template_file" "dns" {
  template = "${ file( "${ path.module }/dns.yml" )}"
}

data "template_file" "systemd" {
  template = "${ file( "${ path.module }/systemd" )}"
}
