#!/bin/bash

# 
#  fordan.sh
#  by lethe
#
#  This script builds matching 'mod_auth_svn.so' and 'mod_dav_svn.so' for Mac OS X 10.12
#

# Download and unzip files
cd ~/Downloads
curl 'http://archive.apache.org/dist/apr/apr-1.6.2.tar.bz2' > ~/Downloads/apr-1.6.2.tar.bz2
bunzip2 apr-1.6.2.tar.bz2
tar -xf apr-1.6.2.tar
curl 'http://archive.apache.org/dist/apr/apr-util-1.6.0.tar.bz2' > ~/Downloads/apr-util-1.6.0.tar.bz2
bunzip2 apr-util-1.6.0.tar.bz2
tar -xf apr-util-1.6.0.tar
curl 'https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.bz2' > ~/Downloads/pcre-8.41.tar.bz2
bunzip2 pcre-8.41.tar.bz2
tar -xf pcre-8.41.tar
curl 'http://mirror.bit.edu.cn/apache//httpd/httpd-2.4.27.tar.bz2' > ~/Downloads/httpd-2.4.27.tar.bz2
bunzip2 httpd-2.4.27.tar.bz2
tar -xf httpd-2.4.27.tar

# Install dependency
cd ~/Downloads/apr-1.6.2/
./configure --prefix=/usr/local/apr
sudo make
sudo make install

cd ~/Downloads/apr-util-1.6.0/
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/
sudo make
sudo make install

cd ~/Downloads/pcre-8.41/
./configure --prefix=/usr/local/pcre --with-apr=/usr/local/apr/
sudo make
sudo make install

cd ~/Downloads/httpd-2.4.27/
./configure --prefix=/usr/local/httpd --with-pcre=/usr/local/pcre --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util
sudo make
sudo make install

# Build mods
cd ~/Downloads/subversion-1.7.19/
./configure --prefix=/Applications/Xcode.app/Contents/Developer/usr --disable-debug --with-zlib=/usr --disable-mod-activation --with-apache-libexecdir=$(/usr/local/httpd/bin/apxs -q libexecdir) --without-berkeley-db --disable-nls --without-serf --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-apxs="/usr/local/httpd/bin/apxs"
make mod_dav_svn mod_authz_svn
cd ~/Downloads

#  Dump used libs
otool -L "subversion-1.7.19/subversion/mod_dav_svn/.libs/mod_dav_svn.so"
otool -L "subversion-1.7.19/subversion/mod_authz_svn/.libs/mod_authz_svn.so"

#  Clean up
echo 'Copying modules to current directory…'
mv "subversion-1.7.19/subversion/mod_dav_svn/.libs/mod_dav_svn.so" './mod_dav_svn.so'
mv "subversion-1.7.19/subversion/mod_authz_svn/.libs/mod_authz_svn.so" './mod_authz_svn.so'

echo 'Deleting temporary files…'
rm -rf "apr-1.6.2"
rm -f "apr-1.6.2.tar.bz2"
rm -rf "apr-util-1.6.0"
rm -f "apr-util-1.6.0.tar.bz2"
rm -rf "pcre-8.41"
rm -f "pcre-8.41.tar.bz2"
rm -rf "httpd-2.4.27"
rm -f "httpd-2.4.27.tar.bz2"

rm -rf "subversion-1.7.19"
rm -f "subversion-1.7.19.tar.bz2"

printf '\n\nAll done!\n'

exit 0
