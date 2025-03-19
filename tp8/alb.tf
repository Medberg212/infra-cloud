resource "aws_lb" "alb" {
  name               = "${local.name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1b.id, aws_subnet.public_1c.id]

  tags = {
    Name = "${local.name}-alb"
  }
}

resource "aws_lb_target_group" "tg_nextcloud" {
  name     = "${local.name}-tg-nextcloud"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.name}-tg-nextcloud"
  }
  #target_type = "instance"
  deregistration_delay = 30
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
    matcher             = "200"
  }
}


resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg_nextcloud.arn
    type             = "forward"
  }
}