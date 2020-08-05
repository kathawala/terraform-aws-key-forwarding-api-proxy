# terraform-aws-key-forwarding-api-proxy
Forward sensitive API keys as query param values to third party APIs using AWS API Gateway as a proxy

## Usage

As an example, imagine you want to use the [Google Places API](https://developers.google.com/places/web-service/overview) in an app.
_But_ you don't want to put your Google Places API Key in your frontend code.

Instead, you can put your API key as a query parameter value in a proxy you created on AWS API Gateway, and forward it with every request
from your frontend code on to the Google Places API.

Here's an example. Imagine your API key is `d7sdauhuf3ewfwej` and the Google Places API URL is `https://maps.googleapis.com/maps/api`

`main.tf`
```hcl
provider "aws" {
    region = "us-east-1"
}

module "key_forwarding_api_proxy" {
    source            = "./key-forwarding-api-proxy"
    name              = "google-places-api-proxy"
    tags = {
       env = "staging"
       api = "Google Places API"
    }
    url               = "https://maps.googleapis.com/maps/api"
    query_param_key   = "key"
    query_param_value = "d7sdauhuf3ewfwej"
}

output "proxy_url" {
    value = module.key_forwarding_api_proxy.url
}
```

Now if you `terraform apply` the above file, you'll get an API proxy from AWS API Gateway with a URL you can use as a drop-in replacement
for the original Places API URL in your frontend code.

Imagine your API proxy URL comes back as `https://3xwdegmpbe.execute-api.us-east-1.amazonaws.com/live`

You could test if your proxy works by trying the following request and see if you get the same output:

``` bash
$ curl "https://3xwdegmpbe.execute-api.us-east-1.amazonaws.com/live/place/search/json?location=33.618389,72.972779&radius=300&types=post_office&sensor=true"
{
   "html_attributions" : [],
   "results" : [
      {
         "business_status" : "OPERATIONAL",
         "geometry" : {
            "location" : {
               "lat" : 33.61868949999999,
               "lng" : 72.9731161
            },
            "viewport" : {
               "northeast" : {
                  "lat" : 33.62010743029149,
                  "lng" : 72.97441303029152
               },
               "southwest" : {
                  "lat" : 33.61740946970849,
                  "lng" : 72.97171506970849
               }
            }
         },
         "icon" : "https://maps.gstatic.com/mapfiles/place_api/icons/post_office-71.png",
         "id" : "ec1a7a0875e550cdb4fe4ab54bfae4051e02f8ac",
         "name" : "Pakistan Post",
         "opening_hours" : {
            "open_now" : false
         },
         "photos" : [
            {
               "height" : 4160,
               "html_attributions" : [
                  "\u003ca href=\"https://maps.google.com/maps/contrib/103011710570639270239\"\u003eSadaf Butt\u003c/a\u003e"
               ],
               "photo_reference" : "CmRaAAAAjZeh9iMZ2d-NedtXCUgUW8Z5l0Bnl5m7cT65_wqG_-nuhP1RvdODnZ7v-v6JqdQlO7UfaGKCj5TGRZwjfrlnVqcKVLAQz62JQs7N1G-zNYx4ZO4hRolhgUfGN6REmsG1EhAqb
lSYiJdYmobBzmvhWpjAGhTewfPEdjfOOMDeozGt5G7JWjqHKw",
               "width" : 3120
            }
         ],
         "place_id" : "ChIJJSmceIyW3zgRt7kx0N0FrqE",
         "plus_code" : {
            "compound_code" : "JX9F+F6 Islamabad, Pakistan",
            "global_code" : "8J5JJX9F+F6"
         },
         "rating" : 4.5,
         "reference" : "ChIJJSmceIyW3zgRt7kx0N0FrqE",
         "scope" : "GOOGLE",
         "types" : [ "post_office", "finance", "point_of_interest", "establishment" ],
         "user_ratings_total" : 4,
         "vicinity" : "Street 50, Islamabad"
      }
   ],
   "status" : "OK"
}
```

## Additional Information

The current module will create cloudwatch logs for any errors received by your proxy.
Those logs will be cleaned up on `terraform destroy`.
