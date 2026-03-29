# Openbao based helm deployment

1. Add openbao repo in helm
```
helm repo add openbao https://openbao.github.io/openbao-helm
```

2. Search OpenBao Chart (Optional)
```
helm search repo openbao/openbao
```

3. Start openbao in isolated namespace.
```
helm install openbao openbao/openbao   -n openbao   --create-namespace   -f openbao-server/values.yaml
```

4. Init Bao Operator
```
kubectl exec -it openbao-0 -n openbao -- bao operator init
```
Keep these keys somewhere secure.

5. Unseal it 3 times with different keys. basically decrypt the store.
```
kubectl exec -it openbao-0 -n openbao -- bao operator unseal
```

6. Login Bao
```
kubectl exec -it openbao-0 -n openbao -- bao login
```

7. Enable Kubernetes Based Auth
```
kubectl exec -it openbao-0 -n openbao -- \
bao auth enable kubernetes
```

8. Configure Kubernetes Auth
```
kubectl exec -it openbao-0 -n openbao -- sh -c '
export BAO_ADDR=http://127.0.0.1:8200
SA_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
K8S_HOST=https://$KUBERNETES_PORT_443_TCP_ADDR:443

bao write auth/kubernetes/config \
  token_reviewer_jwt="$SA_TOKEN" \
  kubernetes_host="$K8S_HOST" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
'
```

9. Enable KV v2
```
kubectl exec -it openbao-0 -n openbao -- \
bao secrets enable -path=kv -version=2 kv
```

10. Store Secrets
```
kubectl exec -it openbao-0 -n openbao -- \
bao kv put kv/dev/orders-api/mongodb \
  username=orders-dev-user \
  password=orders-dev-pass
```

11. Create nameserver
```
kubectl create ns dev
```

12. Run Bootstrap script to create policies, and roles 
```
./bootstrap-vault.sh
```

13. Deploy Helm Chart for Openbao Integration in target Env
```
helm install vault-dev . -f values.yaml -n dev --set targetEnv=dev
```

14. Testing if our secrets are added properly
```
kubectl apply -f ./test-deployment.yaml -n dev
kubectl logs <PODNAME> -n staging
```

## Force Refreshing Secrets

Run following command to refresh External Secret for a particular env when secrets are updated:
```sh
kubectl annotate externalsecret \
  --all \
  -n dev \
  force-sync=$(date +%s) --overwrite

# Restart All Deployment if they are consuming the secrets
kubectl rollout restart deployment -n dev
```