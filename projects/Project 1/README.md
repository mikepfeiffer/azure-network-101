# Single VNet Design & Network Segmentation

In this project you'll build a traditional two-tier web app with database and front-end servers. To keep things simple we'll use Wordpress.

![Project 1 Diagram: Single VNET Design & Segmentation](https://user-images.githubusercontent.com/5126491/165640825-8e4ef365-3552-4fbf-88d7-d066f112973f.jpg)

## 1. Build and Deploy your VNET

Create a new VNET in the WEST US 2 region with the following configuration.

| Components  | CIDRs                |
| ----------- | -----------          |
| VNET        | 192.168.0.0/16       |
| WEB Subnet  | 192.168.1.0/24       |
| SQL Subnet  | 192.168.2.0/24       |

*Note: You can use the ARM template in the [/templates](https://github.com/mikepfeiffer/azure-network-101/tree/main/projects/Project%201/templates) folder of this repo to build the VNET and the servers in [step 2](https://github.com/mikepfeiffer/azure-network-101/tree/main/projects/Project%201#2-deploy-linux-vms).*

## 2. Deploy Linux VMs

Next, you'll need servers to act as the web front-end and database servers.

* Deploy an Ubuntu 18.04 LTS VM into your "WEB" subnet and name this server "WEB-001"
* Deploy an Ubuntu 18.04 LTS VM into your "SQL" subnet and name this server "SQL-001"

*Note: Triple check and make sure you deploy these servers into the correct subnets.*

## 3. Configure Your Web Server

Open the cloud shell and SSH to your WEB server. Run the following commands.

```
apt update -y && apt upgrade -y
apt install apache2 -y
apt install php php-mysql -y
```

This will update the package sources on the VM and install Apache, PHP, and MySql client libraries for PHP.

## 4. Check Status

After Apache is installed verify that the service is running using the following command.

```
systemctl status apache2
```

If Apache isn't running make sure you ran each command in [step 3](https://github.com/mikepfeiffer/azure-network-101/tree/main/Project%201#3-configure-your-web-server).

## 5. Configure Your SQL Server

Go back to the cloud shell and SSH to your SQL server. Run the following commands.

```
apt update -y && apt upgrade -y
apt install mariadb-server mariadb-client -y
```

This will update the package sources on the VM and install MySQL.

## 6. Update MySQL

We need to allow connections from the WEB server in the "WEB" subnet to connect to MySQL server in the "SQL" subnet. Edit the *50-server.cnf* file and change the SQL server IP to the private local IP (192.168.2.4). 

```
nano /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mysql
ufw allow mysql
```

You'll use the first command to edit the file with *nano*, and the remaining commands will restart MySQL and allow connectivity via the local firewall.

## 7. Create a Database

Open the cloud shell and SSH to the SQL server. Run the following commands to create a new database for wordpress.

```
mysql -u root -p
CREATE DATABASE wordpress_db;
CREATE USER 'wp_user'@'192.168.1.4' IDENTIFIED BY 'P@ssw0rd2020';
GRANT ALL ON wordpress_db.* TO 'wp_user'@'192.168.1.4' IDENTIFIED BY 'P@ssw0rd2020';
FLUSH PRIVILEGES;
Exit;
```

Notice that we're granting access to a user at a specific IP address... this is the private IP of the web server.

## 8. Install Wordpress on WEB Server

Open the cloud shell and SSH to the WEB server. Run the following commands. This will download and install wordpress on the server.

```
cd /tmp && wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
cp -R wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R www-data:www-data /var/www/html/wp-content/uploads/
```

Navigate to the public IP of your web server. Can you get to the wordpress site? If not, check your **WEB-NSG** security rules.

## 9. Optimize the Configuration

You should have wordpress working at this point, but there's a lot of issues with the current setup. Let's implement some best practices.

* Configure the IPs on your servers for static assignment
* Disassociate the NSGs from both of your servers
* Create ASGs for both the "WEB" and "SQL" application tiers
* Configure the SQL NSG to permit MySQL traffic from only the "WEB" ASG
* Associate your NSGs with their respective subnets (WEB, SQL) in the VNET
* Disassociate the public IP from your SQL server

Also... we shouldn't SSH directly to the servers. Remove the SSH rule from the web server NSG and make sure it only permits HTTP application traffic. At this stage it should already be disabled for SQL. In a future project we'll setup load balancers for the web tier.

## 10. Setup Remote Access

Add a new subnet to your VNET so we can deploy Azure Bastion for remote access.

| Subnet Name        | CIDR            |
| -----------        | -----------     |
| AzureBastionSubnet | 192.168.0.0/26  |

Deploy a new Bastion to this subnet and verify that you can still SSH to your servers through it.

## Challenge: Set up a Domain and Public DNS

Implement public DNS by registering an [App Service Domain](https://docs.microsoft.com/en-us/azure/app-service/manage-custom-dns-buy-domain) and mapping a [DNS record](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain?tabs=a%2Cazurecli) to the public IP of your web server.

## Recommended Reading


* [OSI Model](https://www.tutorialspoint.com/ipv4/ipv4_osi_model.htm)
* [IPv4 Addressing](https://www.tutorialspoint.com/ipv4/ipv4_addressing.htm)
* [IPv4 Address Classes](https://www.tutorialspoint.com/ipv4/ipv4_address_classes.htm)
* [IPv4 Subnetting](https://www.tutorialspoint.com/ipv4/ipv4_subnetting.htm)
* [Azure network level segmentation](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/network-level-segmentation)
* [Azure network security overview](https://docs.microsoft.com/en-us/azure/security/fundamentals/network-overview)

## Course Index
[mikepfeiffer/azure-network-101](https://github.com/mikepfeiffer/azure-network-101)