# Null provider
resource "null_resource" "example" {
}

# Using our custom plugin
data "extip" "external_ip" {}

output "external_ip" {
  value = "${data.extip.external_ip.ipaddress}"
}
