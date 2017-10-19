data "template_file" "corefile" {
  template = "${ file( "${ path.module }/corefile" )}"
  vars {
    domain = "${ var.domain }"
  }
}

data "template_file" "dns" {
  template = "${ file( "${ path.module }/dns.yml" )}"
}

