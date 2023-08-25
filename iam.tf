data "aws_iam_policy_document" "ec2_policy" {
  statement {
    sid = "EC2SSMPermission"
    actions = [
      "ssm:StartSession",
      "ssm:UpdateInstanceInformation",
      "ssm:CreateAssociation",
      "ssm:DeleteAssociation",
      "ssm:DescribeInstanceAssociations",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceStatus"
    ]
    resources = [
      "*"
    ]
  }
}

module "ec2_iam_policy" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy?ref=v5.28.0"

  name        = "ec2-policy"
  path        = "/"
  description = "Policy for ec2-instance"

  policy = data.aws_iam_policy_document.ec2_policy.json
}
