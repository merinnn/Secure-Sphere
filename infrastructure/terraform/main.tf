# VPC Definition
resource "aws_vpc" "securesphere_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "SecureSphere-VPC" }
}

# 1. Outer Tier (Public Web / Ingress DMZ)
resource "aws_subnet" "web_dmz" {
  vpc_id                  = aws_vpc.securesphere_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "SecureSphere-Web-DMZ" }
}

# 2. Middle Tier (Private Application Subnet)
resource "aws_subnet" "app_tier" {
  vpc_id     = aws_vpc.securesphere_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = { Name = "SecureSphere-App-Tier" }
}

# 3. Inner Tier (Restricted Database Vault)
resource "aws_subnet" "db_vault" {
  vpc_id     = aws_vpc.securesphere_vpc.id
  cidr_block = "10.0.3.0/24"
  tags = { Name = "SecureSphere-DB-Vault" }
}

# Firewall Rule: DB Vault ONLY accepts traffic on 5432 from App Tier
resource "aws_security_group" "db_sg" {
  name        = "db-vault-sg"
  description = "Strict inbound access to DB Vault"
  vpc_id      = aws_vpc.securesphere_vpc.id

  ingress {
    description     = "Allow PostgreSQL from App Tier only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["10.0.2.0/24"] # Strictly App Tier CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}