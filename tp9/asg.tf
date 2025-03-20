resource "aws_autoscaling_group" "asg" {
  name                = "${local.user}-nextcloud"
  max_size            = 5
  min_size            = 1
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_subnet.private_1a.id, aws_subnet.private_1b.id, aws_subnet.private_1c.id]
  target_group_arns   = [aws_lb_target_group.tg_nextcloud.arn]
  enabled_metrics     = ["GroupInServiceInstances", "GroupTerminatingInstances"]

  launch_template {
    id = aws_launch_template.ami_ubuntu.id
  }

  tag {
    key                 = "Owner"
    value               = local.user
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "incr" {
  name                   = "${local.user}-nextcloud-scalein"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "decr" {
  name                   = "${local.user}-nextcloud-scaleout"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}