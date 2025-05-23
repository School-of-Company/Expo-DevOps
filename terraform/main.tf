module "vpc" {
  source = "./modules/vpc"

  name               = "expo-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  protected_subnets  = ["10.0.201.0/24", "10.0.202.0/24"]
  enable_nat_gateway = true
}

module "sg" {
  source = "./modules/sg"

  name   = "expo"
  vpc_id = module.vpc.vpc_id
}

module "bastion" {
  source = "./modules/bastion"

  name                 = "expo-bastion"
  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnets[0]
  security_group_ids   = [module.sg.bastion_sg_id]
  key_name             = var.key_name
  iam_instance_profile = module.iam.bastion_instance_profile_name
}

module "iam" {
  source = "./modules/iam"

  name = "expo"
}

module "ecr" {
  source = "./modules/ecr"

  name = "expo-ecr"
}

module "acm" {
  source = "./modules/acm"

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  wait_for_validation       = false
}

module "alb" {
  source = "./modules/alb"

  name               = "expo-alb"
  internal           = false
  security_group_ids = [module.sg.alb_sg_id]
  subnet_ids         = module.vpc.public_subnets
  vpc_id             = module.vpc.vpc_id
  enable_https       = true
  certificate_arn    = module.acm.certificate_arn
}

module "ecs_fargate" {
  source = "./modules/ecs-fargate"

  cluster_name              = "expo-cluster"
  task_family               = "expo-task"
  container_name            = "expo-container"
  container_image           = "${module.ecr.repository_url}:latest"
  service_name              = "expo-service"
  subnet_ids                = module.vpc.private_subnets
  security_group_ids        = [module.sg.ecs_sg_id]
  target_group_arn          = module.alb.target_group_arn
  execution_role_arn        = module.iam.ecs_execution_role_arn
  task_role_arn             = module.iam.ecs_task_role_arn
  enable_container_insights = true
  desired_count             = 2
  task_cpu                  = 256
  task_memory               = 512
}

module "s3_image" {
  source = "./modules/s3"

  name                        = "expo-image"
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  cloudfront_arn              = module.cloudfront.distribution_arn
  tags = {
    Environment = "production"
  }
}

module "s3_qr" {
  source = "./modules/s3"

  name                        = "expo-qr"
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  cloudfront_arn              = module.cloudfront.distribution_arn
  tags = {
    Environment = "production"
  }
}

module "rds" {
  source = "./modules/rds"

  subnet_ids         = module.vpc.protected_subnets
  security_group_id  = module.sg.rds_sg_id
  db_username        = var.db_username
  db_password        = var.db_password
}

module "amplify" {
  source = "./modules/amplify"
}

module "lambda" {
  source = "./modules/lambda"
}

module "codebuild" {
  source = "./modules/codebuild"
}

module "codepipline" {
  source = "./modules/codepipeline"
}

module "elasticache" {
  source = "./modules/elasticache"

  subnet_ids        = module.vpc.protected_subnets
  security_group_id = module.sg.elasticache_sg_id
}

module "cloudfront" {
  source = "./modules/cloudfront"

  name              = "expo"
  s3_origin_domain  = module.s3_image.image_bucket_regional_domain_name
  alb_origin_domain = module.alb.alb_dns_name
  certificate_arn   = module.acm.certificate_arn
  expo_qr_s3_domain = module.s3_qr.qr_bucket_regional_domain_name
  tags = {
    Environment = "production"
  }
}