## Global Configuration
variable "gconfig" {
  description = "Global Configuration"
  type = object({
    project_name = string  
#    billing_account = string
#    org_id = string
    region = string
    zone = list(any)
#    vpc = string
    image = string
#    keyname = string
#    rhn-user = string
#    rhn-pass = string
#    subnet = string
    subnets_cidr = list(any)
#    docker-token = string
    ssh-user = string
#    cluster = string#
  })
   default = {
    project_name = "evident-ethos-345407"   // Mention project name of your choice.
#    billing_account = ""   // Mention alphanumeric ID of the billing account this project belongs to.
#    org_id = ""            // Mention numeric ID of the organization this project belongs to.
    region = "asia-south1"
    zone = ["asia-south1-a", "asia-south1-b,asia-south1-c"]
    #vpc = "vpc-053b4780392581bfd"
    image = "debian-cloud/debian-11"
    #keyname = "flexy"
    #rhn-user = ""
    #rhn-pass = ""
    #subnet = "subnet-0515516e44579196b"
    subnets_cidr = ["10.164.28.0/24", "10.164.29.0/24"]
    #docker-token = ""
    ssh-user = "buzzworks"
    #cluster = "flexy-cluster"
  }
}
## Port - Protocol Definition
variable "ports" {
  type = map
  default = {
    "22"  = "TCP"
    "443"  = "TCP"
    "80"  = "TCP"
    "3232" = "TCP"
    "3233" = "TCP"
    "7443" = "TCP"
    "5432" = "TCP"
    "5433" = "TCP"
    "5434" = "TCP"
    "8021" = "TCP"
    "8080" = "TCP"
    "6379" = "TCP"
    "8084" = "TCP"
    "5080" = "UDP"
    "23260" = "TCP"
    "16384" = "UDP"
    "1025" = "TCP"
 }
}
# Application specific configuration
variable "config" {
  description = "Application Specific configuration."
  type = map(object({
    type = string
    count = number
    subnet = string
    publicip = bool
    loadbalancer = number
    cidr = string
    volume = map(any)
    ports = map(any)
    load_balancer_type = string
    enable_deletion_protection = bool
    port = number
    internal = bool
    protocol = string
    ltype = string
    ssl_policy = string
    certificate_arn=string
  })
  )
  default     = {
    "app" = {
        "type" = "e2-micro" ## Need an t3.large atleast
        "count" = 1 ## Need an 15 Instance and revision required
        "subnet" = "subnet-09d2e7ac9e5f64a42"
        "publicip" = false
        "loadbalancer" = 1
        "cidr" = "10.164.29.0/24"
        "volume" = {
          size = 10 ## Need to increase
          vtype = "gp2" ## Need to change to gp3
          iops = "100" ## Need to increase higher for better speed
          "delete_protect" = true
        }
        "ports" = {
          "22"  = "22"
          "443"  = "443"
          "80"  = "80"
          "3232" = "3233"
          "8084"  = "8087"
        }
        "load_balancer_type" = "application"
        "enable_deletion_protection" = false
        "port" = 443
        "internal" = false
        "protocol" = "HTTPS"
        "ltype" = "forward"
        "ssl_policy" = "ELBSecurityPolicy-2016-08"
        "certificate_arn"   = "arn:aws:acm:ap-south-1:738583687880:certificate/cc61e151-436c-48c8-b35d-4ec11db0bfc2"
    },
    "db" = {
      "type" = "e2-micro" ## Need an c5.xlarge as minimum
      "count" = 1 ## Disable Ec2 Creation for DB. Using RDS DB
      "subnet" = "subnet-0515516e44579196b"
      "publicip" = false
      "loadbalancer" = 0 ## Disable DB Load balancer due to RDS DB
      "cidr" = "10.164.29.0/24"
      "volume" = {
          size = 10 ## Need to increase
          vtype = "pd-standard" ## Need to change as 'pd-balanced' or higher
          iops = "100" ## Need to increase
          "delete_protect" = true
        }
      "ports" = {
          "22"  = "22"
          "80" = "80"
          "5432"  = "5432"
          "5433"  = "5433"
          "5434"  = "5434"
          "6379"  = "6379"
          "23260"  = "23260"
        }
      "load_balancer_type" = "network"
        "enable_deletion_protection" = false
        "port" = 5432
        "internal" = false
        "protocol" = "TCP"
        "ltype" = "forward"
        "ssl_policy" = ""
        "certificate_arn"   = ""
    },
    "telephony" = {
      "type" = "t2.micro" ##Need an c5.xlarge atleast
      "count" = 1 ## Need to increase 30 and revision required with higher instance
      "subnet" = "subnet-0232b1e09d449e09c"
      "publicip" = false
      "loadbalancer" = 0
      "cidr" = "10.164.29.0/24"
      "volume" = {
          size = 10 ## Need to increase
          vtype = "gp2" ## Need to change as gp3
          iops = "100" ## Need to increase
          "delete_protect" = true
        }
      "ports" = {
          "22"  = "22"
          "5080"  = "5080"
          "7443" = "7443"
          "8021" = "8021"
          "8080"  = "8080"
          "16384" = "32768"
        }
      "load_balancer_type" = ""
      "enable_deletion_protection" = false
      "port" = 0
      "internal" = false
      "protocol" = ""
      "ltype" = ""
      "ssl_policy" = ""
      "certificate_arn"   = ""
    },
    "redis" = {
      "type" = "t2.micro" ##Need an c5.xlarge as minimum
      "count" = 1 ## Only one
      "subnet" = "subnet-0515516e44579196b"
      "publicip" = false
      "loadbalancer" = 0
      "cidr" = "10.164.29.0/24"
      "volume" = {
          size = 10 ## Need to increase
          vtype = "gp2" ## Need to change as gp3
          iops = "100" ## Need to increase
          "delete_protect" = true
        }
      "ports" = {
          "22"  = "22"
          "6379"  = "6379"
        }
      "load_balancer_type" = ""
      "enable_deletion_protection" = false
      "port" = 0
      "internal" = false
      "protocol" = ""
      "ltype" = ""
      "ssl_policy" = ""
      "certificate_arn"   = ""
    },
    "websocket" = {
      "type" = "t2.micro" ## Need minimum of c5.xlarge
      "count" = 1 ## Only one
      "subnet" = "subnet-0232b1e09d449e09c"
      "publicip" = false
      "loadbalancer" = 0
      "cidr" = "10.164.29.0/24"
      "volume" = {
          size = 10 ## Need to increase
          vtype = "gp2" ## Need to change as gp3
          iops = "100" ## Need to increase
          "delete_protect" = true
        }
      "ports" = {
          "22"  = "22"
          "3232"  = "3233"
          "8084" = "8087"
        }
      "load_balancer_type" = ""
      "enable_deletion_protection" = false
      "port" = 0
      "internal" = false
      "protocol" = ""
      "ltype" = ""
      "ssl_policy" = ""
      "certificate_arn"   = ""
    },
  }
}


## Application specific configuration
#variable "cconfig" {
#  description = "Cluster Specific configuration."
#  type = map(object({
#    cidr = string
#    ports = map(any)
#  })
#  )
#  default     = {
#    "cluster" = {
#      "cidr" = "0.0.0.0/0"
#      "ports" = {
#          "22"  = "22"
#          "443"  = "443"
#          "5432" = "5432"
#        }
#    },
#    "node" = {
#      "cidr" = "0.0.0.0/0"
#      "ports" = {
#          "22"  = "22"
#          "1025"  = "65535"
#        }
#    }
#  }
#}