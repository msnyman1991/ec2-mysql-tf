locals {
  user_data = <<-EOT
    #!/bin/bash

    echo "### INSTALLING MYSQL CLIENT ###"
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
    sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
    sudo yum install -y mysql-community-client

    sleep 60
    sudo rm -rf /var/lib/rpm/.rpm.lock

    echo "### INSTALLING MYSQL SERVER ###"
    sudo yum install -y mysql-community-server

    echo "### START AND ENABLE MYSQLD SERVICE ###"
    sudo service mysqld start
    sudo systemctl enable mysqld

    MYSQL_SERVER_PASSWORD="${random_password.mysql.result}"

    TMP_PASSWORD=$(sudo cat /var/log/mysqld.log  | grep 'temporary password' | awk '{print $11}')

    mysql --connect-expired-password  -u root -h 127.0.0.1 -p$TMP_PASSWORD <<< "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_SERVER_PASSWORD'"

    sudo service mysqld restart

  EOT
}

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
