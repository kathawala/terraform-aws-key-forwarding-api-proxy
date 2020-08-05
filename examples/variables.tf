variable "name" {
  default = "TestBlogMapsProxy"
}

variable "tags" {
  type = map(string)
  default = {
    env = "test"
    rel = "google places api"
  }
}

variable "external_api_url" {
  default = "https://maps.googleapis.com/maps/api"
}

variable "query_param_key" {
  default = "key"
}

variable "query_param_value" {}
