provider "google" {
    credentials = file("/home/buzzworks/.config/application_default_credentials.json")
    project  = var.gconfig.project_name 
    region   = var.gconfig.region 
}

resource "google_compute_network" "vpc" {
  
  name                    = "flexydial-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public-subnet" {
  name          = "flexydial-public-subnet"
  ip_cidr_range = var.gconfig.subnets_cidr[0]
  region        = var.gconfig.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "private-subnet" {
  name          = "flexydial-private-subnet"
  ip_cidr_range = var.gconfig.subnets_cidr[1]
  region        = var.gconfig.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_address" "external-ip" {
  name         = "ipv4-address"
  address_type = "EXTERNAL"
  region       = var.gconfig.region
}

#resource "google_compute_global_address" "global-ip" {
#  project      = var.gconfig.project_name # Replace this with your service project ID in quotes
#  name         = "global-ipv4-address"
#  address_type = "EXTERNAL"
#  ip_version   = "IPV4"
#}

  
resource "google_compute_router" "router" {
  name    = "flexydial-router"
  region  = google_compute_subnetwork.public-subnet.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "flexydial-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}  