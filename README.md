# Drone.io Deployer

*Deploy Drone.io CI on Digital Ocean with Terraform*

You need to:
- Create a [Github API token](https://github.com/settings/tokens)
- Get a [Digital Ocean token](https://cloud.digitalocean.com/settings/api/)
- Generate a random secret for DO - use a [random password generator](https://lastpass.com/generatepassword.php)

1) Ensure you have [terraform installed](https://www.terraform.io/intro/getting-started/install.html).

2) Clone the repository

3) Run with from CLI:

With Docker:
```sh
docker run -i -t hashicorp/terraform:light terraform apply \
    -var "DO_TOKEN=<YOUR-DIGITAL-OCEAN-TOKEN>" \
    -var "private_key=<PATH-TO-YOUR-PRIVATE-KEY>" \
    -var "public_key=<PATH-TO-YOUR-PUBLIC-KEY>"
    -var "DRONE_GITHUB_CLIENT=<VCS-CLIENT-ID>" \
    -var "DRONE_GITHUB_SECRET=<VCS-CLIENT-SECRET>"
```

OR like it's still 2013:

```sh
terraform apply \
    -var "DO_TOKEN=<YOUR-DIGITAL-OCEAN-TOKEN>" \
    -var "private_key=<PATH-TO-YOUR-PRIVATE-KEY>" \
    -var "public_key=<PATH-TO-YOUR-PUBLIC-KEY>"
    -var "DRONE_GITHUB_CLIENT=<VCS-CLIENT-ID>" \
    -var "DRONE_GITHUB_SECRET=<VCS-CLIENT-SECRET>"
```

OR create a `terraform.tfvars` file in root with the content below.

```
# Digital Ocean
droplet_name            = "drone-ci"
droplet_region          = "LON1"
droplet_size            = "512"
DO_TOKEN                = ""

# SSH
public_key              = "/path/to/your/key.pub"
private_key             = "/path/to/your/key"

# GitHub API token
DRONE_GITHUB_CLIENT     = ""
DRONE_GITHUB_SECRET     = ""

# Drone related
DRONE_SECRET            = ""
```

..and run with `terraform apply` in the directory


- [Drone.io Documentation](http://readme.drone.io/setup/overview/)

