Creates a TLS certificate using AWS ACM for domains hosted on Akamai.
The ACM certificate can also be attached to an ALB listener.

Creates the following resources:

* ACM certificate
* Akamai Fast DNS CNAME used to validate TLS certificate
* Optional association with an ALB listener

## Usage

```hcl
module "acm_cert" {
  source = "trussworks/acm-cert-akamai-dns/aws"

  zone_name   = "example.com"
  domain_name = "www.example.com"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.70 |

## Providers

| Name | Version |
|------|---------|
| akamai | n/a |
| aws | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_listener\_arn | (Optional) Associate ACM certificate to and ALB listener. | `string` | `""` | no |
| domain\_name | Domain name to associate with the ACM certificate. | `string` | n/a | yes |
| environment | Environment tag. | `string` | n/a | yes |
| zone\_name | The Akamai Fast DNS zone name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| acm\_arn | The ARN of the validated ACM certificate. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
