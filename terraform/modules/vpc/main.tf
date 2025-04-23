resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "protected" {
  count = length(var.protected_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.protected_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-protected-${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  vpc = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nat"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-nat"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${count.index + 1}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public"
    }
  )
}

resource "aws_route_table" "protected" {
  count = length(var.protected_subnets)

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-protected-${count.index + 1}"
    }
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? length(var.private_subnets) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[0].id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "protected" {
  count = length(var.protected_subnets)

  subnet_id      = aws_subnet.protected[count.index].id
  route_table_id = aws_route_table.protected[count.index].id
} 