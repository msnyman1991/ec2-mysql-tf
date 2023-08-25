module "metric_alarm" {
  source              = "git::https://github.com/terraform-aws-modules/terraform-aws-cloudwatch.git//modules/metric-alarm?ref=v4.3.0"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  threshold           = "0.02"
  period              = "3600"
  alarm_description   = "Stop instance when CPU is low for an hour"
  alarm_name          = "LowCPUAlarm"
  alarm_actions       = ["arn:aws:automate:eu-west-1:ec2:stop"]

  dimensions = {
    InstanceId = module.ec2.id
  }
  statistic = "Average"
}
