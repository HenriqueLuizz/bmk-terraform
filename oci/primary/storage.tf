resource "oci_core_volume" "primary_block0" {
  availability_domain = var.OCI_AD["AD1"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-vol-primary"
  size_in_gbs         = "512"
}

# Conecta primary_block0
resource "oci_core_volume_attachment" "primary_block0Attach" {
  attachment_type = "paravirtualized"
  # attachment_type = "iscsi"
  # compartment_id  = var.compartment_ocid
  instance_id     = oci_core_instance.primary.id
  volume_id       = oci_core_volume.primary_block0.id

  connection {
    type          = "ssh"
    host          = oci_core_instance.primary.public_ip
    user          = "opc"
    private_key   = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /totvs",
      "sudo mkfs.xfs /dev/sdb",
      "sudo mount -t xfs /dev/sdb /totvs",
      "echo '/dev/sdb /totvs xfs defaults,_netdev,nofail 0 2' | sudo tee -a /etc/fstab",
      "echo '2 - attachment disk $(pwd)' | sudo tee -a /tmp/timeline.txt",
      "cp /tmp/.wgetrc ~/.wgetrc",
      "/bin/bash /tmp/start_protheus.sh"
    ]
  }
  
  # Apenas para attachment do tipo ISCSI  (attachment_type = "iscsi")
  # provisioner "remote-exec" {
  #     inline = [
  #       "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
  #       "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
  #       "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l"
  #     ]
  # }
}
