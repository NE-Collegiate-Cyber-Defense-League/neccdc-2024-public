# https://www.packer.io/plugins/provisioners/ansible/ansible

build {
  name = "linux-builder"
  source "source.amazon-ebs.vm" {
    ssh_username = "ec2-user"
    ssh_clear_authorized_keys = true
  }
  
  provisioner "ansible" {
    playbook_file = "../playbook.yml"
    use_proxy     = false
  }
}