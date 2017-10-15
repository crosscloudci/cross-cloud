resource "gzip_me" "corefile" {
  input = "${ data.template_file.corefile.rendered }"
}

data "template_file" "corefile" {
  template = "${ file( "${ path.module }/corefile" )}"
  vars {
    domain = ${ var.domain }
  }
}





resource "gzip_me" "dns" {
  input = "${ data.template_file.corefile.rendered }"
}

data "template_file" "dns" {
  template = "${ file( "${ path.module }/dns.yml" )}"
}





data "template_file" "systemd" {
  template = "${ file( "${ path.module }/systemd" )}"
}
