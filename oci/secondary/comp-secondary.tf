##
## TFORM - VMs Secundarias 
## Define o numero de VMs através da variável INSTANCES.
##

resource "oci_core_instance" "secondary" {
  count               = var.instances
  availability_domain = var.OCI_AD["AD1"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-VM-Secondary${count.index}"

  shape               = var.shape_secondary
  shape_config {
    ocpus = var.instance_ocpus
    memory_in_gbs = var.instance_memory
  }

  create_vnic_details {
    subnet_id           = var.subn_publica
    assign_public_ip    = "true"
    display_name        = "${var.prefix}vnicsec${count.index}"
    hostname_label      = "${var.prefix}vmsec${count.index}"
    private_ip          = cidrhost("10.0.4.0/24", 100 + count.index)
    # defined_tags         = {"TOTVS.COMP_TOTVS": "secondary"}
  }

  source_details {
    source_id=var.source_id["X86_64"]
    boot_volume_size_in_gbs=256
    source_type="image"
  }

  metadata = { 
    ssh_authorized_keys = file(var.ssh_file_public_key)
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "opc"
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/secrets/.wgetrc"
    destination="/tmp/.wgetrc"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/provisioner/start_protheus-sec.sh"
    destination="/tmp/start_protheus-sec.sh"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/totvs_lnx/protheus_bundle_x64-12.1.33-lnx-sec.zip"
    destination="/tmp/protheus_bundle_x64-12.1.33-lnx-sec.zip"
  }
  
  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/totvsappsec01.sh"
    destination="/tmp/totvsappsec01.sh"
  }
  
  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/totvsappsec02.sh"
    destination="/tmp/totvsappsec02.sh"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/totvsdbaccess-sec.sh"
    destination="/tmp/totvsdbaccess-sec.sh"
  }

  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/start.sh"
    destination="/tmp/start.sh"
  }
  
  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/scripts/lnx/stop.sh"
    destination="/tmp/stop.sh"
  }
  provisioner "file" {
    source="/Users/henriqueluiz/Projects/bmk-terraform/oci/provisioner/tnsnames.ora"
    destination="/tmp/tnsnames.ora"
  }
  
  provisioner "remote-exec" {
    inline = ["sudo systemctl stop firewalld",
    "sudo systemctl disable firewalld",
    "echo '1 - provisioner computer $$(pwd)' | sudo tee -a /tmp/timeline.txt"
    ]
  }
}

resource "oci_core_volume" "secondary_block0" {
  count               = var.instances
  availability_domain = var.OCI_AD["AD1"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.prefix}-vol-secondary${count.index}"
  size_in_gbs         = "256"
}

# Conecta secondary_block0
resource "oci_core_volume_attachment" "secondary_block0Attach" {
  count           = var.instances
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.secondary[count.index].id
  volume_id       = oci_core_volume.secondary_block0[count.index].id

  connection {
    type          = "ssh"
    host          = oci_core_instance.secondary[count.index].public_ip
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
      "/bin/bash /tmp/start_protheus-sec.sh"
    ]
  }
}
