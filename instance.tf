resource "google_compute_instance" "vm_instance" {
    project  = "evident-ethos-345407"
    zone     = var.gconfig.zone[0]
    name     = "tf-flexydial-instance"
    machine_type = "e2-micro"

    tags = ["app"]

    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-11"
      }
    }

    network_interface {
    subnetwork = google_compute_subnetwork.public-subnet.name
    access_config {}
  }

  #depends_on = [google_project_service.service]
}
