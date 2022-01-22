echo "Installing MySQL ....................."
echo "Welcome to MySQL"

echo " 1st step : creating a mysql user and a group "
# creating a mysql user and a group
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

echo " 2nd step : Dependencies Installation in progress ....."
# Dependencies Install
yum search libaio >> /tmp/mysqlinstall.log
yum install -y libaio >> /tmp/mysqlinstall.log
yum -y install numactl >> /tmp/mysqlinstall.log
yum install -y libnuma >> /tmp/mysqlinstall.log
yum install -y ld-linux.so.2 >> /tmp/mysqlinstall.log
yum install -y libaio.so.1 >> /tmp/mysqlinstall.log
yum install -y libnuma.so.1 >> /tmp/mysqlinstall.log
yum install -y libstdc++.so.6 >> /tmp/mysqlinstall.log
yum install -y libtinfo.so.5 >> /tmp/mysqlinstall.log
yum remove -y mariadb-libs >> /tmp/mysqlinstall.log
yum install -y wget >> /tmp/mysqlinstall.log
yum clean all >> /tmp/mysqlinstall.log
yum makecache >> /tmp/mysqlinstall.log
yum install -y libstdc++* >> /tmp/mysqlinstall.log
yum install -y libstdc++.so.6 >> /tmp/mysqlinstall.log
yum install -y libtinfo.so.5 >> /tmp/mysqlinstall.log
yum install -y glibc.i686 >> /tmp/mysqlinstall.log
yum install -y mysql-client-core-8.0 >> /tmp/mysqlinstall.log
yum install -y ncurses-compat-libs >> /tmp/mysqlinstall.log

# we will take all in /software directory
echo " 3rd step : we will take all in /software directory in progress ....."
mkdir -p /software
cd /software


echo " 4th step : Download of MySQL 8 in progress ....."
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.24-linux-glibc2.12-i686.tar.xz
tar xvf mysql-8.0.24-linux-glibc2.12-i686.tar.xz
mv mysql-8.0.24-linux-glibc2.12-i686 mysql

echo " 5th step : Important directory (data, log temp build for MySQL 8 in progress) ....."

mkdir -p /software/mysql/data
mkdir -p /software/mysql/temp
mkdir -p /software/mysql/local

chown -R mysql:mysql /software/mysql

echo " 6th step : cnf file configuration is in progress ....."
touch /software/my.cnf

## create a conf file
echo "
[mysql]

# CLIENT #
port                           = 3306
socket                         = /software/mysql/mysql.sock

[mysqld_safe]
nice            = 0
pid-file                       = /software/mysql/mysqld.pid

[mysqld]

# GENERAL #
user                           = mysql
default-storage-engine         = InnoDB
socket                         = /software/mysql/mysql.sock
pid-file                       = /software/mysql/mysqld.pid
skip-external-locking



# Bin, DATA , TEMP, STORAGE #
basedir         = /software/mysql
datadir         = /software/mysql/data
tmpdir          = /software/mysql/temp
" >> /software/my.cnf

rm -rf /software/mysql/data/
cd /software/mysql/bin/


echo " 7th step : Generate Meta data is in progress ....."
# generate Meta data
./mysqld --initialize --user=mysql --basedir=/software/mysql --datadir=/software/mysql/data  --tmpdir=/software/mysql/temp


echo " 8th step : Starting MySQL ....."
#start Mysql
./mysqld_safe --user=mysql &
cd /software/mysql/support-files
cp mysql.server /etc/init.d/mysql

#set the path
export PATH=$PATH:/software/mysql/bin/
pwd

## then manually
## update datadir and basedir on /etc/init.d/mysql
./software/mysql/bin/mysql_secure_installation
