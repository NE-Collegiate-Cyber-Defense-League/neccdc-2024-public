output "server_instance_profiles" {
  value = {
    gitlab         = aws_iam_instance_profile.gitlab.id
    identity       = aws_iam_instance_profile.identity.id
    k8s_ctrl_plane = aws_iam_instance_profile.kubernetes_control_plane.id
    k8s_worker_1   = aws_iam_instance_profile.kubernetes_worker_node_1.id
    k8s_worker_2   = aws_iam_instance_profile.kubernetes_worker_node_2.id
    k8s_worker_3   = aws_iam_instance_profile.kubernetes_worker_node_3.id
    plc            = aws_iam_instance_profile.plc.id
    vault          = aws_iam_instance_profile.vault.id
    wazuh          = aws_iam_instance_profile.wazuh.id
  }
  description = "map of iam role instance profiles"
}
