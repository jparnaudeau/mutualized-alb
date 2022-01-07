locals {
  default_healthcheck = {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  #health_check_settings = merge(local.default_healthcheck, var.health_check)

}
