# DevNation

## Deploy Argo
Create a project for ArgoCD operator to be installed

```
oc new-project argocd
```

Within the OpenShift UI install the ArgoCD operator and deploy ArgoCD.

Expose the route and decode the password
```
oc create route passthrough argocd --service=argocd-server --port=https --insecure-policy=Redirect
```

```
kubectl get secret argocd-cluster -o jsonpath='{.data.admin\.password}' | base64 -d
```

### ArgoCD Binary
Install the argocd binary. Login and upload the git repository

```
wget https://github.com/argoproj/argo-cd/releases/download/v1.5.5/argocd-linux-amd64
mv argocd-linux-amd64 ~/bin/argocd
```

Login
```
argocd login --grpc-web --insecure argocd-argocd.apps.east1.aws.demo-sysdeseng.com:443 --username admin
```

Add the repository
```
argocd repo add git@github.com:cooktheryan/devnation.git --ssh-private-key-path ~/.ssh/id_rsa
```

### Import Clusters
As stated earlier we will be running a modified hub/spoke.
```
argocd cluster add east1
argocd cluster add east2
argocd cluster add west2
```

## Importing an App
We will start out by having an application deployed and then bringing it within GitOps

```
oc create -f simple/simple-app.yaml
```

### Exporting the app
We will remove the file simple/simple-app.yaml. What do we do now?

```
rm simple/simple-app.yaml
```

We can export the running application and save it within git.

```
mkdir letters
oc get deployment -o yaml --export simple-app > letters/deployment.yaml
oc get configmap -o yaml --export index-map > letters/configmap.yaml
oc get service -o yaml --export simple-app-the-service > letters/service.yaml
oc get route -o yaml --export letter > letters/route.yaml
```

The route has to be modified to be used with ArgoCD. ingress: null won't work with ArgoCD well.

```
  ingress:
  - conditions:
    - status: "True"
      type: Admitted
```

Save the code into Git.
```
git add letters/*
git commit -m 'initial commit of our letter of the day'
```
We could have "manual" gitops now but that's no fun.

### Loading App into ArgoCD
We will use the UI to load our simple application

### Making changes
We will now swap the configmap letter of the day and delete the current running pod.

```
https://toppng.com/uploads/preview/icture-freeuse-library-alphabet-png-images-page-stickpng-free-illustration-letters-alphabet-11563734483yvqwzwpnok.png```

### 
