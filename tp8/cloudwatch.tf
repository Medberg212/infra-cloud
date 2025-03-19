resource "aws_cloudwatch_metric_alarm" "nextcloud_asg_scaleout" {
  alarm_name          = "mberguella-tp8-nextcloud-asg-scaleout"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 1000
  alarm_actions       = [aws_autoscaling_policy.incr.arn]
  metric_query {
    id = "mq1"
    return_data = true

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "RequestCountPerTarget"

      period = 60
      stat   = "Sum"
      dimensions = {
        TargetGroup = aws_lb_target_group.tg_nextcloud.arn_suffix
      }
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "nextcloud_asg_scalein" {
  alarm_name          = "mberguella-tp8-nextcloud-asg-scalein"
  comparison_operator = "LessThanThreshold"
 threshold           = 400
  alarm_actions       = [aws_autoscaling_policy.decr.arn]
  evaluation_periods  = 1
  metric_query {
    id = "mq2"
    return_data = true

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "RequestCountPerTarget"

      period = 60
      stat   = "Sum"
      dimensions = {
        TargetGroup = aws_lb_target_group.tg_nextcloud.arn_suffix
      }
    }
  }
}

resource "aws_cloudwatch_dashboard" "nextcloud" {
  dashboard_name = "${local.name}-nextcloud-asg"
  dashboard_body = jsonencode(
    {
      periodOverride = "inherit"
      start          = "-PT30M"
      widgets = [
        {
          height = 6
          properties = {
            legend = {
              position = "bottom"
            }
            liveData = true
            metrics = [
              [
                "AWS/AutoScaling",
                "GroupInServiceInstances",
                "AutoScalingGroupName",
                aws_autoscaling_group.asg.name,
                {
                  color = "#2ca02c"
                  label = "InServiceInstances"
                },
              ],
              [
                ".",
                "GroupTerminatingInstances",
                ".",
                ".",
                {
                  color = "#d62728"
                  label = "TerminatingInstances"
                },
              ],
            ]
            period = 60
            region = "eu-north-1"
            stat   = "Average"
            title  = "ASG - In Service/Terminating Instances"
          }
          type  = "metric"
          width = 24
          x     = 0
          y     = 0
        },
        {
          height = 6
          properties = {
            annotations = {
              horizontal = [
                {
                  color = "#2ca02c"
                  label = "Add Instance"
                  value = 1000
                },
                {
                  color = "#d62728"
                  label = "Remove Instance"
                  value = 400
                },
              ]
            }
            legend = {
              position = "bottom"
            }
            metrics = [
              [
                "AWS/ApplicationELB",
                "RequestCountPerTarget",
                "TargetGroup",
                aws_lb_target_group.tg_nextcloud.arn_suffix,
              ],
            ]
            period = 60
            region = "eu-north-1"
            stat   = "Sum"
            title  = "ALB - Request Count Per Target"
          }
          type  = "metric"
          width = 24
          x     = 0
          y     = 6
        },
      ]
    }
  )
}