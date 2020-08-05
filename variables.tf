variable "name" {
  type        = string
  description = "The name of the API Gateway resource displayed in AWS"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags attached to the API Gateway resource in AWS"
}
variable "url" {
  type        = string
  description = "URI of the external third party API which requests are proxied to"
}
variable "query_param_key" {
  type        = string
  description = "The key of the query parameter being injected into the request (e.g. the {KEY} in 'http://example.com/posts?{KEY}={VALUE}')"
}
variable "query_param_value" {
  type        = string
  description = "The key of the query parameter being injected into the request (e.g. the {VALUE} in 'http://example.com/posts?{KEY}={VALUE}')"
}
