module "vpc" {
  source          = "../modules/vpc"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_2b_cidr = var.pub_sub_2b_cidr
  pri_sub_3a_cidr = var.pri_sub_3a_cidr
  pri_sub_4b_cidr = var.pri_sub_4b_cidr
  pri_sub_5a_cidr = var.pri_sub_5a_cidr
  pri_sub_6b_cidr = var.pri_sub_6b_cidr
}

module "nat" {
  source = "../modules/nat"

  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  igw_id        = module.vpc.igw_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
}

module "alb" {
  source        = "../modules/alb"
  project_name  = var.project_name
  alb_sg_id     = module.security-group.alb_sg_id
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  vpc_id        = module.vpc.vpc_id

}

module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "asg" {
  source        = "../modules/asg"
  project_name  = var.project_name
  key_name      = module.key.key_name
  client_sg_id  = module.security-group.client_sg_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  tg_arn        = module.alb.alb_tg_arn

}

module "cloudfront" {
  source                  = "../modules/cloudFront"
  certificate_domain_name = var.certificate_domain_name
  additional_domain_name  = var.additional_domain_name
  alb_domain_name         = module.alb.alb_dns_name
  project_name            = var.project_name

}

module "route53" {
  source                    = "../modules/route53"
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id

}


module "key" {
  source = "../modules/key"
}

module "rds" {
  source        = "../modules/rds"
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
  username      = var.db_username
  password      = var.db_password
  db_sg_id      = module.security-group.db_sg_id

}



