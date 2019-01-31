/**
 * Creates a TLS certificate using AWS ACM for domains hosted on Akamai.
 * The ACM certificate can also be attached to an ALB listener.
 *
 * Creates the following resources:
 *
 * * ACM certificate
 * * Akamai Fast DNS CNAME used to validate TLS certificate
 * * Optional association with an ALB listener
 *
 * ## Usage
 *
 * ```hcl
 * module "acm_cert" {
 *   source = "trussworks/acm-cert-akamai-dns/aws"
 *
 *   zone_name   = "example.com"
 *   domain_name = "www.example.com"
 * }
 * ```
 */

resource "aws_acm_certificate" "main" {
  domain_name       = "${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name        = "${var.domain_name}"
    Environment = "${var.environment}"
    Automation  = "Terraform"
  }
}

resource "akamai_fastdns_zone" "main" {
  hostname = "${var.zone_name}"

  cname {
    # expects just the name, not an FQDN, so remove the zone name from resource_record_name
    name = "${replace(aws_acm_certificate.main.domain_validation_options.0.resource_record_name,
                      format(".%s.", var.zone_name),
                      "")}"

    ttl    = 60
    active = true
    target = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_value}"
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = "${aws_acm_certificate.main.arn}"

  validation_record_fqdns = ["${format("%s.%s",
                                       lookup(akamai_fastdns_zone.main.cname[0], "name"),
                                       var.zone_name)}"]
}

resource "aws_lb_listener_certificate" "main" {
  count = "${var.alb_listener_arn != "" ? 1 : 0}"

  listener_arn    = "${var.alb_listener_arn}"
  certificate_arn = "${aws_acm_certificate.main.arn}"

  depends_on = ["aws_acm_certificate_validation.main"]
}
