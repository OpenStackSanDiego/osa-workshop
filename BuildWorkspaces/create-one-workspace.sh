#!/bin/bash
#
# account running this script should have sudo group
#
if [ "$#" -ne 1 ] ; then
  echo "Usage: $0 lab-number" >&2
  exit 1
fi

LAB_NUMBER="$1"

#must be lower case since usernames must be lowercase
LAB_NAME="osa"

PACKET_AUTH_TOKEN=""
PACKET_FACILITY=""

if [ -z "$PACKET_AUTH_TOKEN" ] ; then
  echo "please set the PACKET_AUTH_TOKEN"
  exit 1
fi

if [ -z "$PACKET_FACILITY" ] ; then
  echo "please set the PACKET_FACILITY"
  exit 1
fi

echo PACKET_AUTH_TOKEN=$PACKET_AUTH_TOKEN
echo PACKET_FACILITY=$PACKET_FACILITY

rm -rf osa-workshop
git clone https://github.com/OpenStackSanDiego/osa-workshop
cd osa-workshop

# Terraform needs access to these to install plugins
chmod 755 ~root
touch ~root/.netrc
chmod 777 ~root/.netrc

# setup the new student account
USER=$LAB_NAME$LAB_NUMBER
echo "Creating $USER"
#  encrypted password is openstack
sudo useradd -d /home/$USER -p 42ZTHaRqaaYvI -s /bin/bash $USER -G sudo
sudo mkdir /home/$USER
sudo chown $USER.sudo /home/$USER
sudo chmod 2775 /home/$USER


echo ""                                       >  terraform/terraform.tfvars
echo packet_auth_token=\"$PACKET_AUTH_TOKEN\" >> terraform/terraform.tfvars
echo lab_number=\"$LAB_NUMBER\"               >> terraform/terraform.tfvars
echo lab_name=\"$USER\"                       >> terraform/terraform.tfvars
echo terraform_username=\"$USER\"             >> terraform/terraform.tfvars
echo project_name=\"$USER $PACKET_FACILITY\"  >> terraform/terraform.tfvars
echo packet_facility=\"$PACKET_FACILITY\"     >> terraform/terraform.tfvars

# copy over the student files from the base template
sudo -u $USER cp -r terraform /home/$USER/
pushd /home/$USER/terraform
sudo touch terraform.tfstate
sudo chown $USER.sudo terraform.tfstate
sudo -u $USER terraform init
screen -dmS $USER-terraform-apply terraform apply -auto-approve
popd
