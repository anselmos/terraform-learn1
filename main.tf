terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    ansible = {
      source = "ansible/ansible"
      version = ">=1.3.0"
    }
  }
}

provider "docker" {
  host     = "ssh://anselmos@hpt620:22"
  # ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "docker_image" "yt-dlp-web-ui" {
  name         = "marcobaobao/yt-dlp-webui:latest"
  keep_locally = true
}

resource "docker_container" "yt" {
  image = docker_image.yt-dlp-web-ui.image_id
  name  = "ytdlp-webui"
  ports {
    internal =3033
    external = 8033
  }
  restart = "always"
  mounts {
    target = "/downloads"
    source = "/media/500G/ytdlp"
    type = "bind"
    read_only = false
  }
}
resource "ansible_host" "hpt620" {
  name = "192.168.0.10"
  groups = ["ubuntu24"]
  variables = {
    ansible_user = "anselmos"
    ansible_ssh_private_key_file = "~/.ssh/hpt620"
    ansible_python_interpreter   = "/usr/bin/python3"
    ansible_ssh_common_args      = "-o StrictHostKeyChecking=no"
  }
}
resource "ansible_vault" "secrets" {
  vault_file          = "vault.yml"
  vault_password_file = ".vaultpass.txt"
}
resource "ansible_playbook" "playbook" {
  playbook = "playbook.yml"
  name = "hpt620"
  replayable = true
  vault_files          = ["vault.yml"]
  vault_password_file = ".vaultpass.txt"
  # extra_vars = {
    # ansible_python_interpreter   = "/usr/bin/python3"
    # ansible_python_version = "3.12.3"
  # }
}
