

Clone this repo.

```
cp terraform.tfvars.sample terraform.tfvars
```

Get your **User API key** (not Project API key) following these directions under "User Level API Key":
https://support.packet.com/kb/articles/api-integrations
```
echo packet_auth_token=\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\" >> terraform.tfvars
```


This TF creates a new project for this cloud. Give your project a name so you can identify it.
```
eho project_name = \"OSA-dave\" >> terraform.tfvars
```

Terraform - See [Terraform Download](https://www.terraform.io/downloads.html)
```
terraform init
```

```
terraform plan
```

Running TF will deploy the hardware and run all the OSA playbooks. This will take 1/2 hour.

```
terraform apply
```

Once the cloud is up, you can log into the infra host.


```
ssh root@<control_ip> -i default.pem
```

See [Cirros.sh](Cirros.sh) for steps to startup your first instance.
