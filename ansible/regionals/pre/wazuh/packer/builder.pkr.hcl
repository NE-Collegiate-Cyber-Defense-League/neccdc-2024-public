build {
  name = "linux-builder"
  source "source.amazon-ebs.vm" {
    ssh_username = "ec2-user"
    ssh_clear_authorized_keys = true
  }
  
  provisioner "ansible" {
    playbook_file = "../playbook.yaml"
    use_proxy     = false
  }
}