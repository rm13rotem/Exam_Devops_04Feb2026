module "my_infrastructure" {

  source = "./module_directory/"

  vpc_cidr        = "10.0.0.0/16" 
  subnet_count     = 2        
  instance_type    = "t2.micro"   
  if_public_ip = true 
  
}

output "instance_ips" {

  value = module.my_infrastructure.public_instance_ip
}

