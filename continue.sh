#!/bin/bash
cd /var/www/html/resourcespace
if [ -f "filestore" ]; then
    echo "File exists"
else
    sudo mkdir filestore
    sudo chmod -R 777 filestore
    sudo chmod -R 777 include
fi
#Create resourcespace config
sudo touch /etc/httpd/conf.d/resourcespace.conf
sudo tee /etc/httpd/conf.d/resourcespace.conf > /dev/null <<EOF
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
    Order deny,allow
    Deny from all
</Directorymatch>
EOF
sudo systemctl restart httpd
#php.ini
sudo sed -i s'/^memory_limit.*/memory_limit = 999M/' /etc/php.ini
sudo sed -i s'/^post_max_size.*/post_max_size = 999M/' /etc/php.ini
sudo sed -i s'/^upload_max_filesize.*/upload_max_filesize = 999M/' /etc/php.ini
sudo systemctl restart php-fpm
