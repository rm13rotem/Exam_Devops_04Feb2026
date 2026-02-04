module "my_infrastructure" {

  source = "./module_directory/"

  vpc_range        = "10.0.0.0/16" 
  subnet_count     = 2        
  instance_type    = "t2.micro"   
  if_Public_ip = true 
  
}

output "instance_ip" {
  value = module.my_infrastructure.public_instance_ip
}

