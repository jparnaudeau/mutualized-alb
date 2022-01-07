/*
resource "aws_lb_listener_certificate" "listeners-cert" {
  for_each = { for item in var.domains : item.name => item }

  certificate_arn = aws_acm_certificate.this[each.key].arn
  listener_arn    = var.alb_listener_arn
}
*/


data "aws_lb_listener" "selected" {
  for_each = { for item in var.domains : item.name => item if item.listener != null }

  port              = each.value.listener.port
  load_balancer_arn = each.value.listener.alb_arn
}


resource "aws_lb_listener_certificate" "listeners-cert" {
  for_each = { for key, item in data.aws_lb_listener.selected : key => item }

  certificate_arn = aws_acm_certificate.this[each.key].arn
  listener_arn    = data.aws_lb_listener.selected[each.key].arn
}
