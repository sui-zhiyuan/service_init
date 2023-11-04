apt update && apt upgrade && apt install zsh

useradd -m -s /usr/bin/zsh suizhiyuan
# add pub key to $HOME/authorized_keys

# sudo 
echo 'suizhiyuan ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/suizhiyuan

#### as current user setup

### change ssh port
sudo echo 'Port 50131' > /etc/ssh/sshd_config.d/change_port.conf ## todo sudo

## docker
sudo apt update && sudo apt upgrade && sudo apt install docker
sudo usermod -aG docker $USER

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose



# squid
sudo apt update && sudo apt install squid
sudo apt install apache2-utils
sudo htpasswd -c /etc/squid/passwords your_squid_username

# https://www.digitalocean.com/community/tutorials/how-to-set-up-squid-proxy-on-ubuntu-20-04

http_port 50105
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
acl localnet src 111.197.240.59
http_access allow authenticated



curl -v -x http://abcde:qwer1234zxcv@47.245.124.104:50105 https://www.google.com/

curl -v -x http://abcde:qwer1234zxcv@47.245.124.104:50105 https://github.com/

# https://www.smoothnet.org/squid-proxy-with-ssl-bump/
openssl genrsa -out example.com.private 2048
openssl req -new -key example.com.private -out example.com.csr
openssl x509 -req -days 3652 -in example.com.csr -signkey example.com.private -out example.com.cert

#http://wiki.squid-cache.org/ConfigExamples/Intercept/SslBumpExplicit

openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout myCA.pem  -out myCA.pem
openssl x509 -in myCA.pem -outform DER -out myCA.der


http_port 3128 ssl-bump \
  cert=/etc/squid/ssl_cert/myCA.pem \
  generate-host-certificates=on dynamic_cert_mem_cache_size=4MB

# For squid 3.5.x
sslcrtd_program /usr/local/squid/libexec/ssl_crtd -s /var/lib/ssl_db -M 4MB

# For squid 4.x
# sslcrtd_program /usr/local/squid/libexec/security_file_certgen -s /var/lib/ssl_db -M 4MB

acl step1 at_step SslBump1

ssl_bump peek step1
ssl_bump bump all


# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04

#  https://openvpn.net/community-resources/how-to/


iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE