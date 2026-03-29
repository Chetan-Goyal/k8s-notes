# WSL Custom Ubuntu Setup

## 1. Downloaded Ubuntu WSL RootFS

Downloaded Ubuntu 22.04 WSL image (Jammy LTS root filesystem).

Example file:
ubuntu-22.04-server-cloudimg-amd64-wsl.rootfs.tar.gz

Source:
https://cloud-images.ubuntu.com/wsl/

---

## 2. Created Installation Directory

Created a dedicated directory for the custom distro:

```powershell
mkdir D:\projects\k8s-notes\wsl
```

This directory stores the virtual disk (ext4.vhdx) for the distro.

---

## 3. Imported Ubuntu with Custom Name

Used manual import instead of `wsl --install`.

```powershell
wsl --import k8s-dev D:\projects\k8s-notes\wsl D:\projects\k8s-notes\ubuntu-22.04-server-cloudimg-amd64-wsl.rootfs.tar.gz --version 2
```

This created a WSL2 distro named:
k8s-dev

---

## 4. Verified Installation

```powershell
wsl -l -v
```

Confirmed:
- Distro name: k8s-dev
- Version: 2

---

## 5. Checked Current Linux User

Inside WSL:

```bash
whoami
```

For detailed info:

```bash
id
```

---

## 6. (If Needed) Configure Default User

Created a non-root user:

```bash
adduser chetan
usermod -aG sudo chetan
```

Set as default in /etc/wsl.conf:

```bash
echo -e "[user]\ndefault=chetan" | sudo tee /etc/wsl.conf
```

Restarted distro:

```powershell
wsl --terminate k8s-dev
wsl -d k8s-dev
```