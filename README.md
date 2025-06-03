# GitHub Actions Demo: Deploy NGINX to EC2 with Ansible

This repository demonstrates how to deploy and configure NGINX on an AWS EC2 instance using **GitHub Actions** and **Ansible**. The deployment is fully automated via a CI/CD workflow triggered on pushes to the `main` branch or manually via the GitHub UI.

---

## Overview

- Uses **GitHub Actions** runner to install Ansible and run the playbook.
- Connects securely to an EC2 instance using SSH with private keys stored as GitHub Secrets.
- Deploys NGINX, configures firewall rules, and deploys a custom index.html.
- Verifies that NGINX is running and serving HTTP traffic.

---

## Repository Secrets

Before running the workflow, configure the following **repository secrets** in your GitHub repository settings under **Settings > Secrets and variables > Actions**:

| Secret Name  | Description                            |
|--------------|------------------------------------|
| `EC2_HOST`   | Public DNS or IP address of your EC2 instance |
| `EC2_USER`   | SSH username (commonly `ubuntu`)    |
| `EC2_SSH_KEY`| Private SSH key to connect to EC2 instance |

---

## GitHub Actions Workflow

- Workflow file: `.github/workflows/deploy.yml`
- Triggers on:
  - Push to the `main` branch
  - Manual trigger via the Actions tab

### Key Steps:

1. Checkout repository code.
2. Install Ansible on the Ubuntu runner.
3. Setup SSH private key from GitHub secrets.
4. Add EC2 host to known SSH hosts.
5. Test SSH connectivity to EC2.
6. Generate Ansible inventory dynamically.
7. Run Ansible playbook `deploy-nginx.yml` to deploy and configure NGINX.
8. Verify NGINX is running by curling the EC2 host.

---

## Usage

1. Push code changes to the `main` branch or manually trigger the workflow.
2. Watch the workflow run in the **Actions** tab.
3. Once successful, access your deployed NGINX server at:

```
http://<your-ec2-host-url>
```

---

## Playbook

The Ansible playbook performs:

- System update
- NGINX installation and service start
- UFW firewall configuration to allow HTTP and SSH
- Deployment of a custom animated `index.html`
- Verification of NGINX response

---

## Notes

- Make sure your EC2 instance’s security group allows inbound SSH (port 22) and HTTP (port 80) traffic.
- Your private key should have appropriate permissions (`chmod 600`).
- This demo is ideal for learning GitHub Actions, Ansible, and basic infrastructure automation.

---

## License

MIT License

---

*Created by PranaySawant*
