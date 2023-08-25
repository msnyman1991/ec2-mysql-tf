module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//"
  
  name = "ec2-vpc"

  cidr = "10.1.0.0/16"
  private_subnets = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  flow_log_max_aggregation_interval    = 60
  create_flow_log_cloudwatch_iam_role  = true

  azs = ["eu-west-1a","eu-west-1b","eu-west-1c"]

  enable_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    Name = "ec2-vpc-private-subnet"
  }

  private_route_table_tags = {
    Name = "ec2-vpc-private-rt"
  }

  public_route_table_tags = {
    Name = "ec2-vpc-public-rt"
  }

}
