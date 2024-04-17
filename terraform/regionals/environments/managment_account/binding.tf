resource "aws_organizations_policy_attachment" "restrict_leave_org" {
  policy_id = aws_organizations_policy.restrict_leave_org.id
  target_id = data.aws_organizations_organizational_units.ou.children[0].id
}

resource "aws_organizations_policy_attachment" "restrict_instance_types" {
  policy_id = aws_organizations_policy.restrict_instance_types.id
  target_id = data.aws_organizations_organizational_units.ou.children[0].id
}

resource "aws_organizations_policy_attachment" "service_allow_list" {
  policy_id = aws_organizations_policy.service_allow_list.id
  target_id = data.aws_organizations_organizational_units.ou.children[0].id
}

resource "aws_organizations_policy_attachment" "prevent_black_team_removal" {
  policy_id = aws_organizations_policy.prevent_black_team_removal.id
  target_id = data.aws_organizations_organizational_units.ou.children[0].id
}
