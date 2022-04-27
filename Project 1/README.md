# Basic Network Design & Segmentation

1. Deploy VNET
2. SSH to WEB Server

```
apt update -y && apt upgrade -y
apt install apache2 -y
apt install php php-mysql -y
```

Check Status

```
systemctl status apache2
```

3. SSH to SQL

```
apt update -y && apt upgrade -y
apt install mariadb-server mariadb-client -y
nano /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mysql
ufw allow mysql
```

SQL setup

```
mysql -u root -p
CREATE DATABASE wordpress_db;
CREATE USER 'wp_user'@'192.168.1.4' IDENTIFIED BY 'P@ssw0rd2020';
GRANT ALL ON wordpress_db.* TO 'wp_user'@'192.168.1.4' IDENTIFIED BY 'P@ssw0rd2020';
FLUSH PRIVILEGES;
Exit;
```

4. Install Wordpress on WEB Server

```
cd /tmp && wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
cp -R wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R www-data:www-data /var/www/html/wp-content/uploads/
```

## Recommended Reading

Secure and govern workloads with network level segmentation
* https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/network-level-segmentation

Azure network security overview
* https://docs.microsoft.com/en-us/azure/security/fundamentals/network-overview

## Course Index
[mikepfeiffer/azure-network-101](https://github.com/mikepfeiffer/azure-network-101)