


```
cp terraform.tfvars.sample terraform.tfvars
```

```
sed -i "s/terraform_username=.*/terraform_username=\"$LOGNAME\"/g" terraform.tfvars
```

```
echo packet_auth_token=\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\" >> terraform.tfvars
echo packet_project_id=\"12345678-90AB-CDEF-GHIJ-KLMNOPQRSTUV\" >> terraform.tfvars
```

```
terraform init
```

```
terraform plan
```

```
terraform apply
```




