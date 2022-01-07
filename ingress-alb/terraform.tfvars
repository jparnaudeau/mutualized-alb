# Global infos & tags
environment            = "sbx"
application_short_name = "ingress"
product_name           = "network-ingress"
short_description      = "alb"
costcenter             = "XYZ"
owner                  = "jparnaudeau@ippon.fr"

# informations for the domain 
domain_name = "sbx.aws.ippon.fr"

# allow IP Address to request the ALB
# 147.161.180.189/32 = My IP address

allow_inbound_from_cidr_blocks = ["147.161.180.189/32"]
