#!/bin/bash
#
# account running this script should have sudo group 
# 
if [ "$#" -ne 3 ] ; then
  echo "Usage: $0 Packet-Auth-Token Number-Workspaces-To-Create Packet-Facility" >&2
  exit 1
fi

#must be lower case since usernames must be lowercase
LAB_NAME="osa"

PACKET_AUTH_TOKEN="$1"
NUMBER_WORKSPACES="$2"
PACKET_FACILITY="$3"

echo PACKET_AUTH_TOKEN=$PACKET_AUTH_TOKEN
echo NUMBER_WORKSPACES=$NUMBER_WORKSPACES
echo PACKET_FACILITY=$PACKET_FACILITY

git clone https://github.com/OpenStackSanDiego/osa-workshop
cd osa-workshop

# Terraform needs access to these to install plugins
chmod 755 ~root
touch ~root/.netrc
chmod 777 ~root/.netrc

for i in `seq -w 01 $NUMBER_WORKSPACES`
do
  # setup the new student account
  USER=$LAB_NAME$i
  echo "Creating $USER"
  #  encrypted password is openstack
  sudo useradd -d /home/$USER -p 42ZTHaRqaaYvI -s /bin/bash $USER -G sudo
  sudo mkdir /home/$USER
  sudo chown $USER.sudo /home/$USER
  sudo chmod 2775 /home/$USER


  echo ""                                       >  terraform/terraform.tfvars
  echo packet_auth_token=\"$PACKET_AUTH_TOKEN\" >> terraform/terraform.tfvars
  echo lab_number=\"$i\"                        >> terraform/terraform.tfvars
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
  sleep 600
  popd
done

cat <<EOF >> /etc/ssh/sshd_config
Match user $LAB_NAME*
  PasswordAuthentication yes
EOF
service sshd restart
