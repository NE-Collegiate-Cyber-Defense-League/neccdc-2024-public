resource "aws_security_group" "filler_ssh" {
  for_each = toset(["1", "2", "3", "4", "5", "6", "8"])

  name        = "launch-wizard-${each.value}"
  description = "launch-wizard-${each.value}"
  vpc_id      = aws_vpc.team_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
