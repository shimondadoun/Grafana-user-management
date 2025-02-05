
# Grafana User Management with Terraform

This project uses **Terraform** to manage the installation of a **Grafana instance** on a local **Kubernetes cluster** created with **K3d**. It includes steps to:

1. Set up a **K3d Kubernetes cluster**.
2. Switch the **kubectl context** to the new cluster.
3. Create a **Kubernetes secret** for the **Grafana admin password**.
4. Deploy the **Grafana Helm chart** to the Kubernetes cluster.
5. Add users to **Grafana** from a list defined in the `vars` file, with their passwords pulled securely from **Vault**.
6. Create a new **Grafana organization**.
7. Set **permissions for all users** based on their roles within the new organization.

This is an automated way to configure **Grafana** with multiple users and proper access control, integrated with **Vault** for secret management.

## Prerequisites

Before using this project, ensure the following tools are installed:

- **Terraform** (v0.12+)
- **K3d** (for local Kubernetes clusters)
- **Kubectl** (to interact with the Kubernetes cluster)
- **Go** (for k3d provider)
- **Vault** (for managing secrets)

Additionally, you need the following:

- **Vault server** running and accessible.
- **Terraform Vault provider** configured to interact with your Vault instance.

## Project Overview

### 1. **Install Kubernetes Cluster with K3d**
The project first installs a local **K3d Kubernetes cluster** using **Terraform**. K3d is a lightweight Kubernetes distribution that makes it easy to create a local Kubernetes cluster.

### 2. **Switch kubectl Context**
Once the cluster is created, the project switches the **kubectl context** to use the newly created K3d cluster, ensuring that subsequent `kubectl` commands target the correct Kubernetes instance.

### 3. **Create Kubernetes Secrets**
The project adds the **admin password** for Grafana as a **Kubernetes secret**. This password will be used when setting up the Grafana instance.

### 4. **Release Grafana Helm Chart**
Next, the **Grafana Helm chart** is installed in the Kubernetes cluster. The Helm chart uses the Kubernetes secrets to set the **admin password** for Grafana and configure the instance.

### 5. **Add Users to Grafana**
Users are added to Grafana from a list defined in the `vars` file. Their passwords are securely fetched from **Vault** and used during the user creation process.

### 6. **Create New Organization in Grafana**
The project creates a **new organization** within the Grafana instance, which allows for better user and resource management.

### 7. **Set User Permissions**
User permissions are set according to their roles within the new organization. Roles define what level of access a user has (e.g., Viewer, Editor, Admin).

## Setting Up Vault

To securely manage secrets for Grafana (including user passwords), you need to configure **Vault** and set the appropriate secrets.

### 1. **Set Vault Address in Environment Variables**

The first step is to set the **Vault address** so that Terraform can interact with it:

```bash
export VAULT_ADDR="http://127.0.0.1:8200"  # Adjust this to your Vault address
```

### 2. **Set Vault Token for Terraform**

Next, you need to authenticate with **Vault** by setting the `TF_VAR_vault_token` environment variable for Terraform:

```bash
export TF_VAR_vault_token="your-vault-token"
```

The Vault token can be obtained through your Vault authentication method (e.g., AppRole, token-based authentication).

### 3. **Add Secrets to Vault**

There are three key paths that need to be configured in Vault for this project:

1. **Default Password**:  
   Store the default password for Grafana in Vault at the path `secrets/grafana/default_password`:
   ```bash
   vault kv put secrets/grafana/default_password password="YourDefaultPassword"
   ```

2. **Admin Password**:  
   Store the admin password for Grafana in Vault at the path `secrets/grafana/admin_password`:
   ```bash
   vault kv put secrets/grafana/admin_password password="YourAdminPassword"
   ```

3. **User Passwords**:  
   Store passwords for each user at the path `secrets/grafana/users`, in the form of `username=password`. Example for adding two users:
   ```bash
   vault kv put secrets/grafana/users user1="user1Password" user2="user2Password"
   ```

## Getting Started

### Step 1: Initialize the Terraform Project

Start by initializing the Terraform project to download the necessary providers and modules:

```bash
terraform init
```

This command initializes the working directory containing the Terraform configuration files and downloads required providers (e.g., **K3d**, **Helm**, **Vault**).

### Step 2: Apply the Terraform Configuration

Next, apply the Terraform configuration to set up the entire infrastructure:

```bash
terraform apply -auto-approve
```

This will:

1. Create the **K3d Kubernetes cluster**.
2. Switch the **kubectl context** to the new K3d cluster.
3. Add **Kubernetes secrets** for the Grafana admin password.
4. Deploy **Grafana** using the **Helm chart**.
5. Add **users** to Grafana using passwords fetched from Vault.
6. Create a **new organization** in Grafana and set user permissions according to their roles.

### Step 3: Access Grafana

After Terraform completes, you can access the Grafana instance via the exposed **LoadBalancer** service. you will see the url as an output in terraform.

- The **admin password** can be retrieved from Vault.
- **User credentials** are also managed in Vault and used to log users into Grafana.

### Step 4: Destroy the Project

To clean up and remove all the resources created by Terraform (K3d cluster, Kubernetes secrets, Grafana Helm release, and Grafana users), use the following command:

```bash
terraform destroy -auto-approve
```

This will:

1. Remove the **Grafana Helm release**.
2. Delete the **K3d Kubernetes cluster**.
3. Remove the **Kubernetes secrets** related to Grafana.

After running `terraform destroy`, your local environment will be cleaned up and all resources will be removed.
