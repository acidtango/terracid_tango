# TerracidTango
Terraform Template for AWS Infraestructure

# Overview

This template deploys a VPC accross two availability zones in the region specified (`eu-west-1` is
the default region). For each AZ there is a private and a public subnet. There is one Bastion Host
in the first public subnet to access the instances in the private subnets. There are two `t2.micro`
instances deployed, one in each private subnet, running [RancherOS 1.5](https://rancher.com/rancher-os/).
Finally, all the network plumbing and an Application Load Balancer are deployed to route the traffic
to http port 80 to the EC2 instances.

## Architecture Overview

![](AWS_Infraestructure.png)

# Setup

## Dependencies

- AWS Credentials File ([link](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html))
- terraform ([link](https://www.terraform.io/downloads.html))

For more info on how Terraform works visit the [Getting Starte Guide](https://learn.hashicorp.com/terraform/getting-started/install.html)
and the [Docs](https://www.terraform.io/docs). For more specific information about AWS resources
go to the [AWS Provider Documentation](https://www.terraform.io/docs/providers/aws/index.html).

## Usage

Clone the repository

```sh
git clone git@github.com:acidtango/terracid_tango.git
```

Rename the `terraform.tfvars.example` file to be `terraform.tfvars`:

```sh
mv terraform.tfvars.example terraform.tfvars
```

Modify the file to use your specific credentials:

```
# File where your AWS credentials are stored
aws_credentials_file = "~/.aws/credentials"

# SSH key pair used to create the EC2 instances.
aws_key_name = "your-aws-key"

# AWS CLI profile to use. Defaults to 'default'.
aws_cli_profile = "your-profile"
```

Initialize terraform
```sh
$ terraform init
```

If everything is correct the following command should output an execution plan
```sh
$ terraform plan
```

### First apply - Swarm Initialization

Execute the infrastructure
```sh
$ terraform apply
```

If everything goes right, you should found one instace called `Swarm Manager` in the EC2 dashboard.
This instance will be the Swarm Manager Leader, and after a few moments it should be ready to accept
new nodes.

### Second apply - Configure AutoScalingGroups

Connect to the instance (trough the Bastion Host) and verify that the Swarm is initialized

```sh
$ docker node ls

ID                            HOSTNAME                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
zwqenokj41vl3oho7ulv3d2bp *   example-hostname        Ready               Active              Leader              18.09.1
```

Still inside the instance, get the Manager command
```sh
$ docker swarm join-token manager

To add a manager to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-3h7hxv9sf9arjkk1np1uz37pwmpyts7jndktfrscycl3h4k98z-examplemanagertoken 10.0.1.123:2377
```

And get the Worker command
```sh
$ docker swarm join-token worker

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-3h7hxv9sf9arjkk1np1uz37pwmpyts7jndktfrscycl3h4k98z-exampleworkertoken 10.0.1.123:2377
```

Copy both commands and add them in the `variables.tf` file, in the `swarm_managers_user_data` and
`swarm_workers_user_data`

Next, go to the `ec2_instances.tf` file. Go to the block `resource "aws_launch_template" "swarm_managers"`,
and change the `user_data` key from `"${base64encode("${var.swarm_managers_init_user_data}")}"` to
`"${base64encode("${var.swarm_managers_user_data}")}"`. Finally, uncomment the two commented blocks
in the end of the file.

After all this changes are done, apply the infrastructure once again

```sh
$ terraform apply
```

## Testing your deployment

If the `terraform apply` command completes succesfully, it will output the DNS Address of the Load
Balancer
```
$ terraform apply
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

  alb_dns_name = some.dns.name
```

Connect to that address in a browser and you should see the [Swarmpit](https://swarmpit.io/). Log
in with `admin/admin` and you should see information about your nodes.

If you want to bring down the infraestructure

```sh
terraform destroy
```
