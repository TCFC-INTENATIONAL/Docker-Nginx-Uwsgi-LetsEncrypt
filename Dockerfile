from debian

maintainer MR

# update packages
run apt-get update
run apt-get install apt-get install -y lsb-release
run echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee /etc/apt/sources.list.d/backports.list
run apt-get install -y certbot -t jessie-backports
run echo 'deb http://nginx.org/packages/debian/ `lsb_release -cs` nginx' >> /etc/apt/sources.list
run echo 'deb-src http://nginx.org/packages/debian/ `lsb_release -cs` nginx' >> /etc/apt/sources.list
run curl http://nginx.org/keys/nginx_signing.key | apt-key add -
run apt-get update

# install required packages
run apt-get install -y libjpeg62-turbo-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev uwsgi-emperor vim curl wget libssl-dev python3 uwsgi-plugin-python3 python3-pip nginx git
run pip3 install virtualenv

#create user for api
run useradd -m ap1
run su api -c 'cd && mkdir uwsgi && mkdir backend'
run su api -c 'cd && virtualenv env'

# copy needed files
add . /home/docker/code/

## Make ssh dir
run su api -c 'cd && mkdir .ssh/'
# Copy over private key, and set permissions
run chown -R api:api /home/api/.ssh/

## Fix services 
run rm /etc/nginx/sites-enabled/default
run rm /etc/nginx/nginx.conf
run rm /etc/uwsgi-emperor/emperor.ini
run cp /home/docker/code/nginx.conf /etc/nginx/
run cp /home/docker/code/api.ini /etc/uwsgi-emperor/vassals/
run cp /home/docker/code/emperor.ini /etc/uwsgi-emperor/
run cp /home/docker/code/api.conf /etc/nginx/sites-enabled/
run rm -rf /home/docker

expose 80
expose 443
cmd /etc/init.d/nginx restart restart && /etc/init.d/uwsgi-emperor restart && bash
