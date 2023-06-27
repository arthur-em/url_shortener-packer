packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
# which ami to use as the base
# where to save the ami
  ami_name      = "urlshortener-app-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"

  source_ami_filter {
    filters = {
      name      = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "packer-url_shortener"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
      playbook_file = "/Users/emmanuel/Devops/packer-projects/url_shortener/my-playbook-pkr.yaml"
      ansible_env_vars = ["ANSIBLE_REMOTE_TMP=/tmp"]
    }

}
