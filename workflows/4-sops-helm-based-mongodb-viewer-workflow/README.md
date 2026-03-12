# Mongo Helm with SOPS

**[Note: Never push values-secret.yaml and age.key in the repo. Since it is learning repo, It's pushed]**

1. install SOPS

https://github.com/getsops/sops/releases

2. install age as encryption tool
```bash
sudo apt install age
```

3. create age key pair
```sh
age-keygen -o age.key
mkdir -p ~/.config/sops/age
sudo mv age.key $HOME/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
export SOPS_AGE_KEY_FILE=$HOME/.config/sops/age/keys.txt
```

4. Update public key in .sops.yaml file

5. encrypt the secret file with SOPS
```bash
sops  --encrypt --age <public-KEY from age.key file> values-secret.yaml > secret.enc.yaml
rm values-secret.yaml

# test
sops -d values-secret.enc.yaml
```

6. If old deployment causing issues (Optional)
```sh
helm uninstall dev
kubectl delete secret mongo-stack-mongodb
```


7. Update helm installation
```sh
sops -d values-secret.enc.yaml | \
helm install dev . \
  -f values.yaml \
  -f -
```

8. Upgrade installation
```sh
sops -d values-secret.enc.yaml | \
helm upgrade --install dev . \
  -f values.yaml \
  -f -
```