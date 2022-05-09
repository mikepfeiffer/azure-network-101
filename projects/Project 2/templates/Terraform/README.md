# Hub-Spoke Network topology - deployed through Terraform

Here's how to use the terraform deployment files to deploy the Hub-Spoke Demo and Virtual Machines

#### Pre-requisites

- Terraform V1.1.7
- Azure CLI
- Azure subscription
- Visual Studio Code



## Sign into Azure & Initialise Terraform


1. Open Visual Studio code and clone this repository
2. Navigate to the Terraform Folder inside of Project 2

```
 cd '.\projects\Project 2\templates\Terraform\'
```
3. Initalise Terraform inside of the Terraform folder
   
```
Terraform Init
```
4. Log into the Azure subscription where the resources are being deployed

```
AZ login
```
Your browser will open and ask you to login via your AAD account. If you have access to multiple Azure subscriptions, after logging in, you will need to change to the correct subscription with the following command:

```
az account set --subscription "Insert Subscription name here"
```
## Deploy resources into Azure via Terraform

As you can see in the folder structure, there is numerous Terraform related files, that end with the ".TF" extension. In project 1, we only used two terraform files to deploy our resources in Azure. In this project, the Terraform code is split into numerous files, which deploys different types of resources, such as "networks" and "Virtual Machines".

The variables.tf file controls numerous variables that have been set, such as usernames and names for Virtual machines. 

Please note there are no state files currently being deployed at this stage.

1. After initialising Terraform, We can run a plan command to test whether the Terraform code that has been written, will work. 

```
Terraform Plan
```

After running the plan command, the CLI will indicate what resources are going to be deployed into Azure.

2. If we are happy with the plan, we can go ahead and apply Terraform to deploy the resources into Azure.

```
Terraform apply
```

## Destroying resources in Azure via Terraform

Once we have finished deploying the resources in Azure, they can quickly be removed with a simple destroy command.

```
Terraform destroy
```

## Go Back
[Back to Project 2](https://github.com/mikepfeiffer/azure-network-101/tree/main/projects/Project%202)