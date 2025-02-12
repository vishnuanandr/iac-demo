provider "aws" {
  region     = "us-east-1"
  access_key = "ASIAUBWSDX2ITI3TFAZ7"
  secret_key = "I6gBoB3bR/eKa/u2i8GIpcz0CY4/sdTcRM2WRJzX"
  token = "IQoJb3JpZ2luX2VjENL//////////wEaCWV1LXdlc3QtMSJHMEUCIBVUSk0MNGkYCVzaEc9ggRxRPRkgA8ME9bvVRYfbLn2VAiEA/34UdyIeSI/YZ3+lds6vkC0J0sLG/wBVNTb5pbLXBPMqoAMI6///////////ARABGgwyNzg1Mzk3Nzk3MjkiDNPoCokEGg/EZMwoUSr0AjjmEsCDIR4f09OOliehr/osQUSfw+44sFYWPp+Xb7IZVAi1vpiX7tXl+p16o+i0CyjcTePXuL+0QyJ5dpvyw9ABzW2O7nEpZ90WbnoXNF9FBPA13QhkDd+RZVmUGLuvsgjha8+ms74BasUFycLOJmT5HGYx1PLg9c0TwJjaoBV1qs6VphL+eFS6vhn1gllwTR0ZHgjBXasPHms8tSBWpR99mOtGU7+kU8OzmO0DKe/gd1k+6GbmCqyL2kpQC5UD3qBNxG3gxjTdGj/xRDSqo+t+mgS5TV1OflNKrtK/upHDoEowLbWZm/ikvXbzvZUN121Y7zlTr6z2S+uKXlN7WbR97wRAZNgmmEAR0m6tDXqrqVgiKMWQC6XiT8gs6fte6Qm4+MTF3IA6QfDbWm8p07m9E2iI4ADXvq8HJus95Ew4MCy14CvU8Hvbt/EzCOjDkLQeBznGDV+8NTLYDMPPT4G5VR+CmrBA50QHEIyLeV1sjs9bJDDy1LG9BjqmAUjh3/rYsT4moppWJ0h4FK54VxSGi+sGn1Zek4SV4s3Qia+IE1uZIQuKrvBd/x/2q4fnGsn9LhO6z4Bm+Bn+AkQT/ctW97isv5qgFdBoVnEAkGeQm08emrwGoQCcfQ18hiZPTRSvV50VM/Y4Q4oIWtB4bAslmRwPNeKX4ZOGT6AdCs0ONKj3uPC1j2WrBJmfRRGWoVkCplh8KrPfNICmPIDCIJkjJbQ="
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Demo-VPC"
  }
}
