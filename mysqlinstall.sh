echo "Installing MySQL ....................."
echo "Welcome to MySQL"

echo " 1st step : creating a mysql user and a group "
# creating a mysql user and a group
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

echo " 2nd step : Dependencies Installation in progress ....."
# Dependencies Install
yum install -y pssh &>> /tmp/mysqlinstall.log
yum search libaio &>> /tmp/mysqlinstall.log
yum install -y libaio &>> /tmp/mysqlinstall.log
yum -y install numactl &>> /tmp/mysqlinstall.log
yum install -y libnuma &>> /tmp/mysqlinstall.log
yum install -y ld-linux.so.2 &>> /tmp/mysqlinstall.log
yum install -y libaio.so.1 &>> /tmp/mysqlinstall.log
yum install -y libnuma.so.1 &>> /tmp/mysqlinstall.log
yum install -y libstdc++.so.6 &>> /tmp/mysqlinstall.log
yum install -y libtinfo.so.5 &>> /tmp/mysqlinstall.log
yum remove -y mariadb-libs &>> /tmp/mysqlinstall.log
yum install -y wget &>> /tmp/mysqlinstall.log
yum clean all &>> /tmp/mysqlinstall.log
yum makecache &>> /tmp/mysqlinstall.log
yum install -y libstdc++* &>> /tmp/mysqlinstall.log
yum install -y libstdc++.so.6 &>> /tmp/mysqlinstall.log
yum install -y libtinfo.so.5 &>> /tmp/mysqlinstall.log
yum install -y glibc.i686 &>> /tmp/mysqlinstall.log
yum install -y mysql-client-core-8.0 &>> /tmp/mysqlinstall.log
um install -y ncurses-compat-libs &>> /tmp/mysqlinstall.log
yum install -y expect &>> /tmp/mysqlinstall.log
yum install -y libcrypto.so* &>> /tmp/mysqlinstall.log

# we will take all in /software directory
echo " 3rd step : we will take all in /software directory in progress ....."
mkdir -p /software
cd /software


echo " 4th step : Download of MySQL 8 in progress ....."
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz &>> /tmp/mysqlinstall.log
tar xvf mysql-8.0.28-linux-glibc2.12-x86_64.tar.xz &>> /tmp/mysqlinstall.log
mv mysql-8.0.28-linux-glibc2.12-x86_64 mysql

echo " 5th step : Important directory (data, log temp build for MySQL 8 in progress) ....."

mkdir -p /software/mysql/data
mkdir -p /software/mysql/temp
mkdir -p /software/mysql/local
mkdir -p /software/mysql/log

chown -R mysql:mysql /software/mysql

echo " 6th step : cnf file configuration is in progress ....."
touch /software/my.cnf

## create a conf file
echo "
[mysql]

# CLIENT #
port                           = 3306
socket                         = /software/mysql/mysql.sock

[mysqld]

# GENERAL #
user                           = mysql
default-storage-engine         = InnoDB
socket                         = /software/mysql/mysql.sock
pid-file                       = /software/mysql/mysqld.pid
#skip-external-locking



# Bin, DATA , TEMP, STORAGE #
basedir         = /software/mysql
datadir         = /software/mysql/data
tmpdir          = /software/mysql/temp



# General settings - ensure the binary log is enabled, disable all non-transactional storage engines except CSV (used for logs), etc.
# port = 3306
log_bin
# disabled_storage_engines = MyISAM,BLACKHOLE,FEDERATED,ARCHIVE
#ssl
# auto_increment_increment = 7
# auto_increment_offset = 1

# Binary Log and Replication
# binlog_transaction_dependency_tracking = WRITESET
# server_id = 2
# binlog_format = ROW
# binlog_rows_query_log_events = ON
# gtid_mode = ON
# enforce_gtid_consistency = ON
# log_slave_updates = ON
# master_info_repository = TABLE
# relay_log_info_repository = TABLE
# relay_log_recovery = ON
# transaction_write_set_extraction = XXHASH64
# binlog_checksum = NONE

# Group Replication
# group_replication = FORCE_PLUS_PERMANENT
# group_replication_start_on_boot = OFF
# group_replication_local_address = mysql-1:13306
# group_replication_group_seeds = mysql-2:13306,mysql-3:13306
# group_replication_group_name = c19a9bd9-9772-11e8-b677-000c29679891


#group_replication_local_address = 13306
# group_replication_ip_whitelist = mysql-1,mysql-2,mysql-3

# Enable the Group Replication plugin
# plugin-load = group_replication.so

# Disabling symbolic-links is recommended to prevent assorted security risks
# symbolic-links=0

" >> /software/my.cnf

cp /software/my.cnf /etc/


cd /software/mysql/bin/


echo " 7th step : Generate Meta data is in progress ....."
# generate Meta data
./mysqld --initialize --user=mysql --basedir=/software/mysql --datadir=/software/mysql/data  --tmpdir=/software/mysql/temp &>> /tmp/mysqlinstall.log


echo " 8th step : Starting MySQL ....."
#start Mysql
./mysqld_safe --user=mysql &
cd /software/mysql/support-files
cp mysql.server /etc/init.d/mysql
sed -i '46d' /etc/init.d/mysql
sed -i '47d' /etc/init.d/mysql
sed -i '48d' /etc/init.d/mysql
sed -i '46i basedir=/software/mysql' /etc/init.d/mysql
sed -i '47i datadir=/software/mysql/data' /etc/init.d/mysql


#set the path
#export PATH=$PATH:/software/mysql/bin/
echo 'export PATH="/software/mysql/bin:$PATH"' >> ~/.bash_profile
source ~/.bashrc
echo $PATH

## then manually
## update datadir and basedir on /etc/init.d/mysql
echo " 9th step : MySQL mysql_secure_installation is in progress....."
cd /software/mysql/bin/
echo "Waiting for 30 seconds..."
sleep 30
echo "MySQL Installation is completed "

echo "MySQL Process is active or not ps -grep mysql"
ps -ef | grep mysql
mysql_secure_installation


  MYSQL_ROOT_PASSWORD='Password@123'
  MYSQL=$(grep 'temporary password' /tmp/mysqlinstall.log | awk '{print $13}')

  SECURE_MYSQL=$(expect -c "

  set timeout 10
  spawn mysql_secure_installation

  expect \"Enter password for user root:\"
  send \"$MYSQL\r\"
  expect \"New password:\"
  send \"$MYSQL_ROOT_PASSWORD\r\"
  expect \"Re-enter new password:\"
  send \"$MYSQL_ROOT_PASSWORD\r\"
  expect \"Change the password for root ?\ ((Press y\|Y for Yes, any other key for No) :\"
  send \"y\r\"
  send \"$MYSQL\r\"
  expect \"New password:\"
  send \"$MYSQL_ROOT_PASSWORD\r\"
  expect \"Re-enter new password:\"
  send \"$MYSQL_ROOT_PASSWORD\r\"
  expect \"Do you wish to continue with the password provided?\(Press y\|Y for Yes, any other key for No) :\"
  send \"y\r\"
  expect \"Remove anonymous users?\(Press y\|Y for Yes, any other key for No) :\"
  send \"y\r\"
  expect \"Disallow root login remotely?\(Press y\|Y for Yes, any other key for No) :\"
  send \"n\r\"
  expect \"Remove test database and access to it?\(Press y\|Y for Yes, any other key for No) :\"
  send \"y\r\"
  expect \"Reload privilege tables now?\(Press y\|Y for Yes, any other key for No) :\"
  send \"y\r\"
  expect eof
  ")

  echo $SECURE_MYSQL

echo " 10th Step : Installing MySQL Repo"
yum install -y  https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm &>> /tmp/mysqlinstall.log

echo " 11th Step : Installing MySQL Router"
yum install mysql-router -y &>> /tmp/mysqlinstall.log

echo " 12th Step : Installing MySQL Shell"
yum install mysql-shell -y &>> /tmp/mysqlinstall.log

echo " 13th step : MySQL mysql_secure_installation is completed , The password is 'Password@123' , Please reset the same before go live ....."

echo -e "\033[1;34m***********************************************************************************************************\n"
echo -e "\033[1;32mImportant Step to perform\n"
echo -e "\033[1;34mSet the Password for MySQL\n"
echo -e "\033[1;34mMost of the configuration in cnf is commented , Please go through /etc/my.cnf and enable as per requirement\n"
echo -e "\033[1;32m*********************************************HAVE A GREAT DAY *********************************************\n"