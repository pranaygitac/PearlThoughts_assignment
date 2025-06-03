#!/bin/bash
# scripts/setup-ec2.sh
# This script helps you set up your EC2 instance for the first time

set -e  # Exit on any error

echo "🚀 Setting up EC2 instance for NGINX deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root!"
    exit 1
fi

print_status "Starting EC2 initial setup..."

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
print_status "Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Python3 and pip (needed for Ansible)
print_status "Installing Python3 and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Configure UFW firewall (basic setup)
print_status "Configuring firewall..."
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Don't enable UFW yet - Ansible will do it
print_warning "UFW configured but not enabled yet. Ansible will enable it during deployment."

# Create a non-root user if doesn't exist (good practice)
if ! id "deploy" &>/dev/null; then
    print_status "Creating deploy user..."
    sudo useradd -m -s /bin/bash deploy
    sudo usermod -aG sudo deploy
    
    # Copy SSH keys for deploy user
    sudo mkdir -p /home/deploy/.ssh
    sudo cp ~/.ssh/authorized_keys /home/deploy/.ssh/
    sudo chown -R deploy:deploy /home/deploy/.ssh
    sudo chmod 700 /home/deploy/.ssh
    sudo chmod 600 /home/deploy/.ssh/authorized_keys
fi

# Display system information
print_status "System Information:"
echo "===================="
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Memory: $(free -h | grep '^Mem:' | awk '{print $2}')"
echo "Disk: $(df -h / | tail -1 | awk '{print $4}') available"
echo "Public IP: $(curl -s ifconfig.me || echo 'Unable to detect')"
echo "===================="

print_status "✅ EC2 initial setup completed successfully!"
echo ""
print_status "Next steps:"
echo "1. Make sure your security group allows:"
echo "   - SSH (port 22) from your IP"
echo "   - HTTP (port 80) from anywhere"
echo "   - HTTPS (port 443) from anywhere"
echo ""
echo "2. Add these GitHub Secrets to your repository:"
echo "   - EC2_HOST: $(curl -s ifconfig.me || echo 'YOUR_PUBLIC_IP')"
echo "   - EC2_USER: ubuntu"
echo "   - EC2_SSH_KEY: (contents of your .pem file)"
echo ""
echo "3. Push your code to trigger GitHub Actions deployment!"

print_status "🎉 Ready for deployment!"