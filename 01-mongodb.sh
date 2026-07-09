#! /bin/bash

LOGS_FOLDER="/var/log/roboshop"
sudo mkdir -p $LOGS_FOLDER 
sudo chown -R ec2-user:ec2_user $LOGS_FOLDER
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
        echo -e "$TIMESTAMP [INFO] $2....$G SUCCESS $N" | tee -a $LOGS_FILE
    fi 

}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"