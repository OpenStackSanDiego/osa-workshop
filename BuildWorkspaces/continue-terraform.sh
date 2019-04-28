users=`egrep "^osa..:" /etc/passwd | awk -F: '{print $1;}'`

mkdir /tmp/tf-restart
for user in $users
do
        echo $user
        cd /home/$user/terraform
        chown $user *
        screen -dmS $USER-tf-continue terraform apply --auto-approve
        sleep 300
done
