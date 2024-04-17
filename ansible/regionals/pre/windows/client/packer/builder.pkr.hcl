build {
  name = "windows-builder"

  sources = ["source.amazon-ebs.firstrun-windows"]

  provisioner "powershell" {
    scripts = [
      "./scripts/ansible.ps1",
      "./scripts/setup.ps1"
    ]
  }

  provisioner "ansible" {
    playbook_file   = "../ansible/playbook.yml"
    user            = "Administrator"
    use_proxy       = false
    extra_arguments = [
      "-e",
      "ansible_winrm_server_cert_validation=ignore",
      "-e",
      "ansible_winrm_read_timeout_sec=150",
      "-e",
      "ansible_winrm_operation_timeout_sec=120"
    ]
  }

  provisioner "file" {
    content = templatefile("${path.root}/templates/agent-config.pkrtpl.hcl", {
      windows_username = var.windows_username,
      windows_password = var.windows_password
    })
    destination = "C:\\ProgramData\\Amazon\\EC2Launch\\config\\agent-config.yml"
  }

  provisioner "powershell" {
    inline = [
      "& 'C:/Program Files/Amazon/EC2Launch/ec2launch' reset --clean",
      "& 'C:/Program Files/Amazon/EC2Launch/ec2launch' sysprep --shutdown --clean",
    ]
  }
}
