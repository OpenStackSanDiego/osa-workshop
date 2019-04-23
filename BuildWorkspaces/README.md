
Helper file to build the individual student environments.


## 



Spin up a lab master (jump server)
Create student accounts on the lab master
Copy over the workshop into the students account
Create a new Packet Project for each workshop
Configure the students terraform.tfvars



## Building a Multiple Workshop Environments

These steps walk through setting up a "lab master" and multiple workshop environments to support multiple students each with his/her own dedicated inrastructure. You'll need [Git](https://git-scm.com) and [Terraform](https://www.terraform.io) installed on your workstation to set up the lab environment as well as an account with [Packet](http://www.packet.com/)

### Clone this Repo

On your workstation, clone this repo.

```
git clone git@github.com:OpenStackSanDiego/osa-workshop.git
```

This Terraform to setup the lab master and student environments is located in "BuildWorkspaces"

```
cd BuildWorkspaces/
```

### Packet API Key

Get your **User API key** (not Project API key) following these directions under "User Level API Key":
https://support.packet.com/kb/articles/api-integrations

Create a new project within the Packet GUI to deploy the lab master. The individual student labs will each be in its own project.

### Setup the Terraform Variables

Replace YOUR_PACKET_AUTH_TOKEN and YOUR_PACKET_PROJECT_ID with the details from the previous step.

```
cp terraform.tfvars.sample terraform.tfvars
echo packet_auth_token=\"YOUR_PACKET_AUTH_TOKEN\" >> terraform.tfvars
echo packet_project_id=\"YOUR_PACKET_PROJECT_ID\" >> terraform.tfvars
```

Optionally set the facility and lab master hostname.

```
echo packet_facility=\"SJC1\"                    >> terraform.tfvars
echo hostname=\"lab-master-sjc1\"                >> terraform.tfvars
```

Optionally set the number of labs to spin up. By default, 3 will be spun up osa{01,02,03}.

```
echo number-labs=\"2\"                    >> terraform.tfvars
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

The Terraform will return when the lab master is finished and the accounts created. However, the individual labs are still being created and will finish in approximately 30 minutes.

The individual student projects will be the lab id and the facility i.e. "osa02 nrt1".

### Verify Deployment

Log into the lab master as ```osa01``` and run ```terraform output``` to verify that the student environment has been stood up. The default username is set to "openstack" and password logins via SSH are enabled on the lab master.

### Lab Teardown

Each user project will need to be torn down with a ```terraform destroy``` and then the lab master can be torn down.
