#!/bin/bash

yum install -y php71-cli zip php71-devel php71-mbstring.x86_64 php71-mcrypt.x86_64 php71-pdo.x86_64 php71-pecl-redis.x86_64 php71-mysqlnd.x86_64
cd /tmp
#install Composer and Plugins needed
mkdir composer && cd composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
php composer.phar require hollodotme/fast-cgi-client:^2.0
php composer.phar require symfony/process
#Install Phalcon
git clone --depth=1 "git://github.com/phalcon/cphalcon.git"
cd cphalcon/build && ./install
rm -rf /tmp/cphalcon

mkdir /tmp/layer
cd /tmp/layer
cp -r /tmp/composer/vendor .
cp /opt/layer/bootstrap .
cp /opt/layer/php.ini .
mkdir bin
cp /usr/bin/php bin/
cp /usr/bin/php-cgi bin/

mkdir lib
for lib in libncurses.so.5 libtinfo.so.5 libpcre.so.0; do
  cp "/lib64/${lib}" lib/
done

cp /usr/lib64/libedit.so.0 lib/

cp -a /usr/lib64/php lib/

zip -r /opt/layer/php71.zip .
