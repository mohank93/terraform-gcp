## Outbound Firewall rules
resource "google_compute_firewall" "egress-default" {
  name    = "flexydial-egress-default"
  network = google_compute_network.vpc.name
  allow {
    protocol = "all"
    ports    = []
  }
  direction = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags = []
}

## Inbound Firewall rule - for each instances

resource "google_compute_firewall" "ingress-app" {
  name    = "flexydial-ingress-app"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22","80","443","3232-3233","8084-8087"]
  }
  allow {
      protocol = "icmp"
  }
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["app"]
}

resource "google_compute_firewall" "ingress-db" {
  name    = "flexydial-ingress-db"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22","80","5432-5434","6379","23260"]
  }
  allow {
      protocol = "icmp"
  }
  direction = "INGRESS"
  source_tags = ["app","redis","telephony","websocket"]
  target_tags = ["db"]
}

resource "google_compute_firewall" "ingress-redis" {
  name    = "flexydial-ingress-redis"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22","6379"]
  }
  allow {
      protocol = "icmp"
  }
  direction = "INGRESS"
  source_tags = ["app","db","telephony","websocket"]
  target_tags = ["redis"]
}

resource "google_compute_firewall" "ingress-telephony" {
  name    = "flexydial-ingress-telephony"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22","7443","8021","8080"]
  }
  allow {
    protocol = "udp"
    ports    = ["5080","16384-32768"]
  }
  allow {
      protocol = "icmp"
  }
  direction = "INGRESS"
  source_tags = ["app","db","redis","websocket"]
  target_tags = ["telephony"]
}

resource "google_compute_firewall" "ingress-websocket" {
  name    = "flexydial-ingress-websocket"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22","3232","3233","8084-8087"]
    }
  allow {
    protocol = "icmp"
  }
  direction = "INGRESS"
  source_tags = ["app","db","redis","telephony"]
  target_tags = ["websocket"]
}



