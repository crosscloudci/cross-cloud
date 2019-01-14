# Known Tokens

resource "random_string" "admin" {
  length = 16
  special = false
}

resource "random_string" "bootstrap" {
  length = 16
  special = false
}

data "template_file" "known_tokens_csv" {
  template = "${ file( "${ path.module }/known_tokens.csv" )}"

  vars {
    admin = "${ random_string.admin.result }"
    bootstrap = "${ random_string.bootstrap.result }"
  }
}

output "bootstrap" { value = "${ random_string.bootstrap.result }" }