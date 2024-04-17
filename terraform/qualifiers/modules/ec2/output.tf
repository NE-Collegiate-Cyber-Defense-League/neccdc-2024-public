output "instance_details" {
  value = [
    {
      name       = aws_instance.dc_01.tags.Name
      private_ip = aws_instance.dc_01.private_ip
    },
    {
      name       = aws_instance.ca.tags.Name
      private_ip = aws_instance.ca.private_ip
    },
    {
      name       = aws_instance.win_01.tags.Name
      private_ip = aws_instance.win_01.private_ip
    },
    {
      name       = aws_instance.win_02.tags.Name
      private_ip = aws_instance.win_02.private_ip
    },
    {
      name       = aws_instance.identity.tags.Name
      private_ip = aws_instance.identity.private_ip
    },
    {
      name       = aws_instance.vault.tags.Name
      private_ip = aws_instance.vault.private_ip
    },
    {
      name       = aws_instance.wazuh.tags.Name
      private_ip = aws_instance.wazuh.private_ip
    },
    {
      name       = aws_instance.controlle_plane_node.tags.Name
      private_ip = aws_instance.controlle_plane_node.private_ip
    },
    {
      name       = aws_instance.worker_node_1.tags.Name
      private_ip = aws_instance.worker_node_1.private_ip
    },
    {
      name       = aws_instance.worker_node_2.tags.Name
      private_ip = aws_instance.worker_node_2.private_ip
    },
    {
      name       = aws_instance.plc.tags.Name
      private_ip = aws_instance.plc.private_ip
    },
  ]
}
