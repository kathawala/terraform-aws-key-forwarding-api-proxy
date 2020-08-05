resource "aws_api_gateway_rest_api" "Proxy" {
  name        = var.name
  description = "This is a proxy API which inserts an key value pair into the query parameters of a request and forwards that request an external API"
  tags        = var.tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "Resource" {
  rest_api_id = aws_api_gateway_rest_api.Proxy.id
  parent_id   = aws_api_gateway_rest_api.Proxy.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "Method" {
  rest_api_id   = aws_api_gateway_rest_api.Proxy.id
  resource_id   = aws_api_gateway_resource.Resource.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" : true
    "method.request.querystring.${var.query_param_key}" : false
  }
}

resource "aws_api_gateway_integration" "Integration" {
  rest_api_id             = aws_api_gateway_rest_api.Proxy.id
  resource_id             = aws_api_gateway_resource.Resource.id
  http_method             = aws_api_gateway_method.Method.http_method
  integration_http_method = aws_api_gateway_method.Method.http_method
  type                    = "HTTP_PROXY"
  uri                     = "${var.url}/{proxy}"
  request_parameters = {
    "integration.request.path.proxy" : "method.request.path.proxy"
    "integration.request.querystring.${var.query_param_key}" : var.query_param_value
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  rest_api_id       = aws_api_gateway_rest_api.Proxy.id
  resource_id       = aws_api_gateway_resource.Resource.id
  http_method       = aws_api_gateway_method.Method.http_method
  status_code       = "200"
  selection_pattern = ""
  depends_on        = [aws_api_gateway_integration.Integration]
}

resource "aws_api_gateway_method_response" "MethodResponse" {
  rest_api_id = aws_api_gateway_rest_api.Proxy.id
  resource_id = aws_api_gateway_resource.Resource.id
  http_method = aws_api_gateway_method.Method.http_method
  status_code = "200"
}

resource "aws_cloudwatch_log_group" "Logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.Proxy.id}/live"
  retention_in_days = 14
}

resource "aws_api_gateway_method_settings" "Settings" {
  rest_api_id = aws_api_gateway_rest_api.Proxy.id
  stage_name  = aws_api_gateway_deployment.Deployment.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
  }
}

resource "aws_api_gateway_deployment" "Deployment" {
  depends_on = [
    aws_api_gateway_integration.Integration,
    aws_cloudwatch_log_group.Logs
  ]
  rest_api_id = aws_api_gateway_rest_api.Proxy.id
  stage_name  = "live"
  lifecycle {
    create_before_destroy = true
  }
}
