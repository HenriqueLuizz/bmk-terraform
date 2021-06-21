resource "oci_database_db_system" "test_db_system" {
    availability_domain = var.OCI_AD["AD1"]
    compartment_id = var.compartment_ocid
    source = var.db_source

    db_home {
        database {
            admin_password = var.db_admin_password
            db_name = var.db_name
            character_set = var.db_character_set
            ncharacter_set = var.db_ncharacter_set

            db_workload = "OLTP" #DATA WAREHOUSE or Transaction Processing
            pdb_name = "pdbDbBmkXk"

            db_backup_config {
              auto_backup_enabled = false
            }
        }

        db_version = var.db_version
        display_name = var.db_name
    }
    hostname = var.db_hostname
    shape = var.shape_db
    cpu_core_count = var.db_ocpus
    
    ssh_public_keys = [file(var.ssh_file_public_key)]
    subnet_id = oci_core_subnet.subn_publica.id
    data_storage_percentage = var.db_percentage

    database_edition = var.db_edition
    disk_redundancy = "NORMAL"
    display_name = "DBSYSBMKXK"
    license_model = var.db_license_model
    node_count = "1"
    private_ip = cidrhost("10.0.4.0/24", 5)
    time_zone = var.db_time_zone
}