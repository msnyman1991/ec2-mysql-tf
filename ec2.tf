module "ec2_security_group" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v5.1.0"

  name        = "ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

module "ec2" {
  source                 = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//?ref=v5.2.1"
  name                   = "ec2-instance"
  ami                    = "ami-0ed752ea0f62749af"
  instance_type          = "t3.small"
  subnet_id              = module.vpc.id[0]
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    EC2InstanceAccess = module.ec2_iam_policy.arn,
    EC2SSMAccess      = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  }

  user_data_base64 = base64encode(local.user_data)
}
