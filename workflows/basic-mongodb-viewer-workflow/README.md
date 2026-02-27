# Mongo Express Web App
![mongo-express](/assets/mongo-express-app.png)
Combined Workflow: [combined.yaml](combined.yaml)

This is a simple workflow to run mongo express web app. Config must be started in order due to dependencies.

[mongodb-configmap.yaml](mongodb-configmap.yaml) -> [mongodb-secrets.yaml](mongodb-secrets.yaml) -> [mongodb-deployment.yaml](mongodb-deployment.yaml) -> [mongoexpress-deployment.yaml](mongoexpress-deployment.yaml)

After Starting the services, run following command if using minikube to expose port:

```minikube service mongo-express-service```

Default Credentials: `admin:password`

## Note
This doesn't secure secrets. It only encodes the credentials with base64 encoding not actual encryption. Use Enterprise solutions like https://github.com/hashicorp/vault.
