resource "aws_autoscaling_group" "asg" {
  name                = "mberguella-tp7-nextcloud"
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_subnet.private_1a.id, aws_subnet.private_1b.id, aws_subnet.private_1c.id]
  target_group_arns   = [aws_lb_target_group.tg_nextcloud.arn]

  launch_template {
    id = aws_launch_template.ami_ubuntu.id
  }

  tag {
    key                 = "Owner"
    value               = local.user
    propagate_at_launch = false
  }
}