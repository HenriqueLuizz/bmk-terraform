output "instance_ip_addr" {
  value = [oci_core_instance.primary.public_ip, oci_core_instance.primary.private_ip]
}
