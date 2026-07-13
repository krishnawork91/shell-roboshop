#! /bin/bash

LOGS_FOLDER="/var/log/roboshop"
sudo mkdir -p $LOGS_FOLDER 
sudo chown -R ec2-user:ec2-user $LOGS_FOLDER
sudo chmod -R 755 $LOGS_FOLDER 
LOGS_FILE="$LOGS_FOLDER/$0.log"

USER_ID=$(id -u)
TIME_STAMP=$(date "+%Y-%m-%d %H:%M:%S")
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USER_ID -ne 0 ]; then 
    echo -e "$TIME_STAMP [ERROR] $R Please run this script with root access $N" | tee -a $LOGS_FILE
    exit 1 
fi 

VALIDATE(){
    if [ $1 -ne 0 ]; then 
        echo -e "$TIME_STAMP [ERROR] $2.... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1 
    else 
        echo -e "$TIME_STAMP [INFO] $2....$G SUCCESS $N" | tee -a $LOGS_FILE
    fi 

}

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo 
VALIDATE $? "Adding rabbitmq repo" 

dnf install rabbitmq-server -y &>> LOGS_FILE
VALIDATE $? "Installing rabbitmq server" 

systemctl enable rabbitmq-server &>> LOGS_FILE
systemctl start rabbitmq-server &>> LOGS_FILE
VALIDATE $? "Enable and starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> LOGS_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> LOGS_FILE
VALIDATE $? "Setting up username and password"

