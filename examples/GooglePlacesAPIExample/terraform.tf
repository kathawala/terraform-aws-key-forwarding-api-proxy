module "key_forwarding_api_proxy" {
  source            = "kathawala/key-forwarding-api-proxy/aws"
  version           = "1.0.0"
  name              = var.name
  tags              = var.tags
  url               = var.external_api_url
  query_param_key   = var.query_param_key
  query_param_value = var.query_param_value
}

output "proxy_url" {
  value = module.key_forwarding_api_proxy.url
}
