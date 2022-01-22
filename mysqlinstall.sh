
echo ""# creating a mysql user and a group"
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

echo "# Dependencies Install"
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

echo "## we will take all in /software directory"

mkdir -p /software
cd /software

wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.24-linux-glibc2.12-i686.tar.xz
tar xvf mysql-8.0.24-linux-glibc2.12-i686.tar.xz
mv mysql-8.0.24-linux-glibc2.12-i686 mysql

mkdir -p /software/mysql/data
mkdir -p /software/mysql/temp
mkdir -p /software/mysql/local

chown -R mysql:mysql /software/mysql

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
basedir         = /software/mysql/local
datadir         = /software/mysql/data
tmpdir          = /software/mysql/temp
" >> /software/my.cnf

rm -rf /software/mysql/data/
cd /software/mysql/bin/

echo"# generate Meta data"
./mysqld --initialize --user=mysql --basedir=/software/mysql --datadir=/software/mysql/data  --tmpdir=/software/mysql/temp

#start Mysql
#./mysqld_safe --user=mysql &
#cd /software/mysql/support-files
#cp mysql.server /etc/init.d/mysql

#set the path
#export PATH=$PATH:/software/mysql/bin/
#pwd

## then manually
## update datadir and basedir on /etc/init.d/mysql
## mysql_secure_installation
