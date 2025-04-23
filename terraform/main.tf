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

  name               = "expo-bastion"
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnets[0]
  security_group_ids = [module.sg.bastion_sg_id]
  key_name           = var.key_name
}

module "iam" {
  source = "./modules/iam"

  name = "expo"
  
}
