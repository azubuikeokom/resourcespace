#!/bin/bash
set -e
sudo yum update -y
sudo yum install -y amazon-efs-utils
sudo amazon-linux-extras install php8.2  #installs php-cli php-common php-fpm php-mysqlnd php-pdo libzip
sudo yum install httpd php-gd php-devel php-mbstring php-intl php-ldap  php-pear gcc subversion -y 
sudo yum install ghostscript -y
sudo yum install ImageMagick -y
sudo yum install poppler -y
sudo amazon-linux-extras install epel -y
sudo amazon-linux-extras install python3.8 -y
sudo yum-config-manager --add-repo http://mirror.centos.org/centos/7/sclo/x86_64/rh
sudo  rpm --import https://www.centos.org/keys/RPM-GPG-KEY-CentOS-SIG-SCLo
sudo rpm --import https://www.cert.org/forensics/repository/forensics-expires-2022-04-03.asc
wget https://forensics.cert.org/repository/cert-forensics-tools-release-amzn2.rpm
sudo yum install cert-forensics-tools-release-amzn2.rpm -y
sudo yum install --skip-broken CERT-Forensics-Tools -y
sudo mount -t efs fs-024ccbe7b33f9b053 /var/www/html
sudo systemctl start httpd
sudo systemctl enable httpd
cd /var/www/html
sudo mkdir resourcespace
cd resourcespace
svn co https://svn.resourcespace.com/svn/rs/releases/10.3 .
sudo mkdir filestore
sudo chmod -R 777 filestore
sudo chmod -R 777 include

#Create resourcespace config
sudo touch /etc/httpd/conf.d/resourcespace.conf
#echo "DocumentRoot /var/www/html/resourcespace" > /etc/httpd/conf.d/resourcespace.conf
sudo cat<<EOF>/etc/httpd/conf.d/resourcespace.conf
DocumentRoot /var/www/html/resourcespace
<Directory /var/www/html/resourcespace>
    Options -Indexes
</Directory>
<Directory /var/www/html/resourcespace/batch>
        Require all denied
</Directory>
<Directory /var/www/html/resourcespace/include>
        Require all denied
</Directory>
<Directory /var/www/html/resourcespace/upgrade>
        Require all denied
</Directory>
<Directory /var/www/html/resourcespace/languages>
        Require all denied
</Directory>
<Directory /var/www/html/resourcespace/tests>
        Require all denied
</Directory>
<Directory /var/www/html/resourcespace/filestore*>
        Require all denied
</Directory>
<Directorymatch "^/.*/\.svn/">
      Order 'deny,allow'
      Deny from all
</Directorymatch>
EOF
#php.ini
sudo sed -i s'/^memory_limit.*/memory_limit = 999M/' /etc/php.ini
sudo sed -i s'/^post_max_size.*/post_max_size = 999M/' /etc/php.ini
sudo sed -i s'/^upload_max_filesize.*/upload_max_filesize = 999M/' /etc/php.ini
sudo systemctl restart php-fpm

#Complete installation on web
# sudo chmod -R 750 include/
# cd ..
# sudo chgrp -R apache resourcespace/

