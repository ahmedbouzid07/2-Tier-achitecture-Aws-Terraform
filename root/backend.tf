terraform {
  backend "s3" {
    bucket         = "2-tier-app-bucket"
    key            = "backend/2-tier-app.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "remote-backend"
  }
}
