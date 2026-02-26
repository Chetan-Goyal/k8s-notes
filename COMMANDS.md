# Commands

1. Minikube Start
```bash
minikube start --driver=docker --container-runtime=docker
```

2. Get Nodes/Deployment/Pod/Replicaset/services
```
kubectl get <KIND>
```
In older version, master was the role for master node.. In new version, it is renamed to control-plane.

Here, `-o wide` can be added at end and it gives additional information

3. Create Deployment
It is abstraction over pod. We can't create a single pod.
```
kubectl create deployment DEPLOYMENT_NAME --image=IMAGE_HERE 
```

Example:
```
kubectl create deployment nginx-depl --image=nginx
```

4. Editing Deployment

```
kubectl edit deployment nginx-depl
```
Here, after updating (changing version to 1.16), k8s will automatically terminate and start a new pod.

5. View Logs

```
kubectl logs mongo-depl
# image = mongo
```

6. Describe Deployment
It shows deployment details and events.

```
kubectl describe <KIND> <RESOURCE_NAME>
```

```
kubectl describe pod mongo-depl
```

7. Interative Terminal inside a pod

```
kubectl exec -it <POD_NAME> -- bin/bash
```

8. Delete Deployment

```
kubectl delete deployment mongo-depl
```

9. Use Configuration File for Applying Changes (Create/Update)
```
kubectl apply -f simple-workflows/nginx-deployment.yaml
```

10. Use Configuration File to Delete (Delete)
```
kubectl delete -f simple-workflows/nginx-deployment.yaml
```

11. Get Yaml with status for a kind

```
kubectl get deployment nginx-deployment -o yaml
```
