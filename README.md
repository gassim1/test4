# Deploying ofinTech-Dask on Kubernetes

1. Build and push the image (from the repo root, with the Dockerfile + .dockerignore copied in):
   docker build -t ghcr.io/ofintech/ofintech-dask:1.0.0 .
   docker push ghcr.io/ofintech/ofintech-dask:1.0.0

2. Edit k8s/configmap.yaml, k8s/ingress.yaml (domain) and the image in k8s/deployment.yaml.

3. Create the namespace and secret:
   kubectl apply -f k8s/namespace.yaml
   kubectl -n ofintech-dask create secret generic ofintech-dask-secrets --from-env-file=.env.secrets

4. Deploy:
   kubectl apply -k k8s/

5. Check:
   kubectl -n ofintech-dask get pods,pvc,ingress
   kubectl -n ofintech-dask logs deploy/ofintech-dask -f

Private registry? Add: kubectl -n ofintech-dask create secret docker-registry regcred ...
and set imagePullSecrets in the Deployment.
