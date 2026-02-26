# Advanced WSL Developer PS1 (No Git Branch)

Goal:
Clean, minimal, high-signal prompt showing:

- Exit status (if previous command failed)
- Username
- WSL distro name
- Current directory
- Kubernetes context
- Modern prompt symbol

Example:

chetan@k8s-dev ~/project [minikube] ❯

If last command fails:

✖ chetan@k8s-dev ~/project [minikube] ❯

---

## 1️⃣ Add Kubernetes Context Function

Open your bash config:

```bash
nano ~/.bashrc
```

Append this function:

```bash
kube_ps1() {
  context=$(kubectl config current-context 2>/dev/null)
  if [ -n "$context" ]; then
    echo " [$context]"
  fi
}
```

---

## 2️⃣ Add Exit Status Indicator

Append this:

```bash
exit_status() {
  status=$?
  if [ $status -ne 0 ]; then
    echo "✖ "
  fi
}
```

---

## 3️⃣ Set the PS1

Add this at the bottom of `~/.bashrc`:

```bash
PS1='$(exit_status)\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;34m\]$WSL_DISTRO_NAME\[\e[0m\] \[\e[1;33m\]\w\[\e[0m\]\[\e[1;36m\]$(kube_ps1)\[\e[0m\] ❯ '
```

---

## 4️⃣ Apply Changes

```bash
source ~/.bashrc
```

---

# Component Breakdown

| Component | Purpose |
|-----------|----------|
| ✖ | Shows if previous command failed |
| \u | Username |
| $WSL_DISTRO_NAME | WSL distro name |
| \w | Current directory |
| [context] | Kubernetes context |
| ❯ | Clean modern prompt symbol |

---