# Terraform with Ansible on HP T620

Finding out how to use Terraform with Ansible for automated deploys.

# Prerequisites:

## On Host:
### Ansible core

### Terraform
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## On GUEST:
- SSH - with ssh key authorized-keys
- ANSIBLE - with ansible vault for sudo password
- DOCKER

##  ansible

### ON HOST install only ansible-core.
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible-core
```
### ON GUEST - full package of ANSIBLE.
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

### Python packages (if needed):

- python3
- python3-dev
- python3-full

```bash
sudo apt -y install software-properties-common;sudo add-apt-repository -y ppa:deadsnakes/ppa;
sudo apt -y install python3.12.3;sudo apt -y install python3.12.3-dev;sudo apt -y install python3.12-full;
sudo rm /usr/bin/python3;sudo ln -s /usr/bin/python3.12 /usr/bin/python3;
```
# Common issues
!! Make sure that your ANSIBLE version on HOST is the same as in GUEST machine you are going to be using.
Otherwise there will be some errors because of version mismatch.

# Ansible vault

You need to create a ansible vault as it contains passwords for smb and sudo
Default name of vault file for this project is `vault.yml`
```bash
ansible-vault create vault.yml --vault-pass-file .vaultpass.txt
```

Where `.vaultpass.txt` contains a plaintext vault password

# Terraform 
In order to use terraform you need to first initialize it with `terraform init` for using terraform providers used in main.tf file.
