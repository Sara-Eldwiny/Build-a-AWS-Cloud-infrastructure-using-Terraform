module "network" {
  source = "./network"
  Vcidr= var.Vcidr
  region= var.region
  Vpublic_cidr1= var.Vpublic_cidr1
  Vprivate_cidr1= var.Vprivate_cidr1
  Vpublic_cidr2= var.Vpublic_cidr2
  Vprivate_cidr2= var.Vprivate_cidr2
  Vpubrouttable_cidr= var.Vpubrouttable_cidr
  commenname= var.commenname
}