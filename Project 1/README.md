# Single VNET Design & Segmentation

In this project you'll build a traditional two-tier web app with database and front-end servers.

1. Build and Deploy your VNET

| Components  | CIDRs                |
| ----------- | -----------          |
| VNET        | 192.168.0.0/16       |
| WEB Subnet  | 192.168.1.0/24       |
| SQL Subnet  | 192.168.2.0/24       |

*Note: You can use the ARM template in the /templates folder of this repo to build the VNET and the servers in step 2 below.*

2. Deploy Linux VMs

* Deploy an Ubuntu 18.04 LTS VM into your "WEB" subnet and name this servers "WEB-001"
* Deploy an Ubuntu 18.04 LTS VM into your "SQL" subnet and name this servers "SQL-001"

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