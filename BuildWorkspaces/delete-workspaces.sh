users=`egrep "^osa..:" /etc/passwd | awk -F: '{print $1;}'`

for user in $users
do
        echo $user
        cd /home/$user/terraform
        terraform destroy --auto-approve
        deluser --force --remove-home $user
done
