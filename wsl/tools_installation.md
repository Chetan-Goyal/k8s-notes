# Install Minikube on WSL2 (Ubuntu 22.04)

This guide installs:

- Docker (container runtime)
- kubectl
- Minikube
- A working local Kubernetes cluster

Assumptions:
- WSL2 Ubuntu installed (e.g., `k8s-dev`)
- Non-root user with sudo access
- Clean environment

---

## 1. Install System Dependencies

```bash
sudo apt update
sudo apt upgrade
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release
```

---

## 2. Install Docker (Recommended Driver)

Minikube works best with Docker inside WSL.

### Install Docker Engine

```bash
sudo apt install -y docker.io
```

Enable and start Docker:

```bash
sudo systemctl enable docker
sudo service docker start
```

Add your user to the docker group:

```bash
sudo usermod -aG docker $USER
```

Restart WSL from Windows:

```powershell
wsl --terminate k8s-dev
wsl -d k8s-dev
```

Verify Docker works:

```bash
docker ps
```

If there is no permission error, Docker is configured correctly.

---

## 3. Install kubectl

Download latest stable version:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install it:

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Verify:

```bash
kubectl version --client
```

---

## 4. Install Minikube

Download binary:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

Install:

```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Verify:

```bash
minikube version
```

---

## 5. Start Kubernetes Cluster

Use Docker driver explicitly:

```bash
minikube start --driver=docker
```

Verify cluster:

```bash
kubectl get nodes
```

Expected output:

```
minikube   Ready   control-plane
```

---

## 6. Test Service Exposure

Deploy nginx:

```bash
kubectl create deployment nginx --image=nginx
```

Expose it as NodePort:

```bash
kubectl expose deployment nginx --type=NodePort --port=80
```

Get assigned port:

```bash
kubectl get svc
```

Access from Windows browser:

```
http://localhost:<nodePort>
```

WSL2 automatically forwards exposed ports to Windows.

---

## Cluster Lifecycle Commands

```bash
minikube stop
minikube start
minikube delete
```
:wq

---

## Notes

- Do not install VirtualBox inside WSL.
- Do not mix Docker Desktop with WSL Docker unless you know what you're doing.
- If Docker fails due to systemd issues, systemd must be enabled in WSL.