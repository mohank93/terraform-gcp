resource "google_compute_instance" "db-instance" {
    project  = var.gconfig.project_name
    count = var.config.db.count
    name     = "db-instance-${count.index}"
    zone     = var.gconfig.zone[0]
    machine_type = var.config.db.type
    allow_stopping_for_update = "true"

    tags = ["app"]

    boot_disk {
      auto_delete = "true"  // Set to 'False', if persistent disk required upon destroy
      initialize_params {
        size  = var.config.db.volume.size
        type  = var.config.db.volume.vtype
        image = var.gconfig.image
      }
    }

    metadata = {
       ssh-keys = "buzzworks:${file("~/.ssh/id_rsa.pub")}"
    }
    
    metadata_startup_script = file("./tools/docker-install.sh")

    network_interface {
       subnetwork = google_compute_subnetwork.private-subnet.name
       access_config { 
         nat_ip = google_compute_address.external-ip.address
       }
    }
    #connection {
    #    type        = "ssh"
    #    host        = google_compute_address.external-ip.address
    #    user        = var.gconfig.ssh-user
    #    private_key = file("~/.ssh/id_rsa")
    #}
    #provisioner "remote-exec" {
    #    inline = [
    #    "echo COUNT=${count.index} | sudo tee -a /etc/environment",
    #    "echo URI=postgres://autoctl_node@127.0.0.1:5432/pg_auto_failover?sslmode=require | sudo tee -a /etc/environment"
    #    ]
    #}
}

#output "instance-global-ip" {
#  value = google_compute_global_address.global-ip
#}

output "instance-private-ip" {
  value = google_compute_address.external-ip.address
}

#data "cloudinit_config" "db" {
#  gzip          = true
##  base64_encode = true
#  part {
#    content_type = "text/x-shellscript"
#    content = templatefile("${path.module}/tools/docker-install.tftpl",{})
#       # RHN-USER: "${var.gconfig.rhn-user}"
#       # RHN-PASSWORD: "${var.gconfig.rhn-pass}"
#    #})
#  }
#  #part {
#  #  content_type = "text/x-shellscript"
#  #  content = templatefile("${path.module}/tools/postgres/docker-instance.tftpl", {
##
#  #  })
#  #}
#}