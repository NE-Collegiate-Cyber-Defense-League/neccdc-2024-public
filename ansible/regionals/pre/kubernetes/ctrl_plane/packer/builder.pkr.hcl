# https://www.packer.io/plugins/provisioners/ansible/ansible

build {
  name = "linux-builder"
  source "source.amazon-ebs.vm" {
    ssh_username = "ubuntu"
  }
  provisioner "ansible" {
    playbook_file = "../playbook.yaml"
    use_proxy     = false
  }
}
