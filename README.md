# Setup Ephemeral jamulus Server
> This project will help you create a game server with jamulus on it. You can create an IAM image with packer with Jamulus and its deps installed. You can create a jamulus server with that image using terraform

# Getting Started
## Create a .pem file
Create a .pem file either locally or on AWS and import it here. it could be called `jamulus.pem`

## Building the IAM Image

Use packer to create the IAM image. `aws_ubuntu20_jamulus.json` is the main packer file with `scripts/deps.sh` being what runs when packer is building

**Building on linux:**
```
# Validate your changes
$ packer validate
$ build.sh <your aws key> <your aws secret>
```

**Building on windows:**
```
# Validate your changes
> packer build -var "aws_access_key=<your aws key>" -var "aws_secret_key=<your aws secret>" -var .\aws_ubuntu20_jamulus.sjon
```

## Create the server

Set up AWS profile vereto in the `~/.aws/credentials` file

```
# Do a dry run (WILL NOT CREATE SERVER)
$ terraform plan

# Make the server (WILL CREATE BILLABLE SERVERS)
$ terraform apply
```

The `scripts/server-start.sh` script will be run on the Jamulus server starting it up and the prometheus service

Changing the region of deployed server can be done under the provider standza but note that packer images are region specific so make sure to rebuild the packer in the desired region

Changing the instance class can be done under the `aws_instance.jamulus` stanza


## Prometheus

Node_exporter is setup by default on the server to be connected to a prometheus instance. For more info see here [https://prometheus.io/docs/guides/node-exporter/](https://prometheus.io/docs/guides/node-exporter/)
