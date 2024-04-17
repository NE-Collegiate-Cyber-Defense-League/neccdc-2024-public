resource "aws_route_table_association" "ad_corp" {
  subnet_id      = aws_subnet.ad_corp.id
  route_table_id = var.networked_route_table_id
}

resource "aws_route_table_association" "id_corp" {
  subnet_id      = aws_subnet.id_corp.id
  route_table_id = var.networked_route_table_id
}

resource "aws_route_table_association" "kubernetes" {
  subnet_id      = aws_subnet.kubernetes.id
  route_table_id = var.networked_route_table_id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = var.private_route_table_id
}
