## Building a Standalone Environment

These steps walk through setting up an individual lab environment. You'll need [Git](https://git-scm.com) and [Terraform](https://www.terraform.io) installed on your workstation to set up the lab environment as well as an account with [Packet](http://www.packet.com/)

### Clone this Repo

On your workstation, clone this repo.

```
git clone git@github.com:OpenStackSanDiego/osa-workshop.git
```

### Packet API Key

Get your **User API key** (not Project API key) following these directions under "User Level API Key":
https://support.packet.com/kb/articles/api-integrations

### Setup the Terraform Variables

Replace ABCDEFGHIJKLMNOPQRSTUVWXYZ123456 with your Packet Auth Token from the previous step.

```
cd terraform/
cp terraform.tfvars.sample terraform.tfvars
echo packet_auth_token=\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\" >> terraform.tfvars
```

This TF creates a new project for this cloud. If you're running multiple labs make sure to give each project a different name. These projects are visible on the Packet GUI.

```
echo project_name = \"OSA-lab-1\" >> terraform.tfvars
```

### Execute Terraform

Download the necessary Terraform providers.
```
terraform init
```

Validate the Terraform plan.
```
terraform plan
```

Apply the Terraform plan.
```
terraform apply
```

It will take approximately 30 minutes for OpenStack Ansible to complete the installation.


### Verify Deployment

At this point, proceed to "Lab01"(Lab01.md) to verify your deployment.

### Lab Teardown

When you're done using the lab, the lab can be torn down and the physical hosts released with ```terraform destroy```. Infrastructure costs from Packet will stop once the physical hosts have been released.
