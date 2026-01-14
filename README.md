# CHR-XX
**MikroTik Cloud Hosted Router (CHR)** on **Proxmox VE**

A simple shell script to automate the installation of **MikroTik Cloud Hosted Router (CHR)** on **Proxmox VE**.  
This script helps you deploy CHR quickly and efficiently from the command line without manual configuration.

---

## 📦 Repository Contents

| File             | Description                                |
|------------------|--------------------------------------------|
| `install-chr.sh` | Main shell script to install CHR on Proxmox |
| `install-chr-7.sh` | Main shell script to install CHR on Proxmox |

---

## 🚀 How to Use

There are two ways to run the script, depending on your preference:

---

### 🔹 Option 1: Run Directly from GitHub (Quick & Easy)

This method is ideal if you want to execute the script instantly without cloning the repository.

#### Using `curl`

```bash
bash <(curl -s https://raw.githubusercontent.com/simda-buru/CHR-XX/main/install-chr.sh)
```
```bash
bash <(curl -s https://raw.githubusercontent.com/simda-buru/CHR-XX/main/install-chr-7.sh)
```
### 🔹 Option 2: Clone the Repository First (Recommended for Review or Customization)

This method is better if you want to inspect or modify the script beforehand.

#### Steps
1.	Clone the repository:
```bash
git clone https://github.com/simda-buru/CHR-XX.git
cd CHR-Proxmox
```
2.	Make the script executable and run it:
```bash
chmod +x install-chr.sh
./install-chr.sh
```
## 📄 License

This project is licensed under the MIT License.

You are free to use, modify, and distribute this script.
Please note that it is provided as-is without any warranty.
