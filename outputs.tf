output "url" {
  value       = aws_api_gateway_deployment.Deployment.invoke_url
  description = "The URL of the API Gateway resource which should replace the URL given in 'external_api_url' in order to proxy requests to the external API"
}