terraform {
  backend "s3" {
    bucket = "buckethterraform"
    key    = "terraformstate"
    region = "us-east-1"
  }}