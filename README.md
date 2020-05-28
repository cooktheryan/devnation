# DevNation

Preload

```
oc create -f /home/rcook/simple/simple-app.yaml
```

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

### Stop
Manually modifying code is unsafe. This can cause potential outages, no change tracking, and general confusion. The same can be said for kubernetes resources.

## Deploy Argo

## Authentication
Since we are setting up our clusters we should setup authentication. This allows us to manage auth between two clusters.

PR a new administrator
mvazquezc


## Importing an App
We will start out by having an application deployed and then bringing it within GitOps

```
oc project simple-app
mkdir letters
oc get deployment -o yaml --export simple-app > letters/deployment.yaml
oc get configmap -o yaml --export index-map > letters/configmap.yaml
oc get service -o yaml --export simple-app-the-service > letters/service.yaml
oc get route -o yaml --export letter > letters/route.yaml
```

Add namespace yaml
```
vi letters/namespace.yaml

apiVersion: v1
kind: Namespace
metadata:
  name: simple-app
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
### Someone deleted the App
```
oc delete project simple-app
```

We could have "manual" gitops now but that's no fun.

### Loading App into ArgoCD
We will use the UI to load our simple application

### Making changes
We will now swap the configmap letter of the day and delete the current running pod.

```
git checkout -b letters
vi letters/configmap.yaml

https://toppng.com/uploads/preview/icture-freeuse-library-alphabet-png-images-page-stickpng-free-illustration-letters-alphabet-11563734483yvqwzwpnok.png
```

commit the code
```
git add configmap.yaml
git commit -m 'new letter of the day'
git push origin letters

### ArgoCD protection
```
oc delete deployment simple-app
```

## Running an application on Multiple clouds
https://quay.io/repository/rcook/pacman-nodejs-app
https://github.com/cooktheryan/pacman

BACKUP: docker.io/cooktheryan/pacman-nodejs-app:latest

```
git checkout master
git pull
git checkout -b game
```

```
git add game
git commit -m 'new game'
git push origin game

Using Argo let's load our application.

## Fixing our broken app
```
base/pacman-deployment.yaml
serviceAccount: pacman

env:
        - name: MY_NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
```

Commit the code
```
git add *
git commit -am 'fixing our game'
git push origin game
```

So now we can see our cloud information

## Moving to Prod
Load East1 into ArgoCD

Create another route to be used for public access.
```
vi base/pacman-public-route.yaml 

apiVersion: route.openshift.io/v1
kind: Route
metadata:
  labels:
    app.kubernetes.io/instance: game
    name: pacman
  name: multicloud
  namespace: pacman
spec:
  host: pacman.demo-sysdeseng.com
  port:
    targetPort: 8080
  to:
    kind: Service
    name: pacman
    weight: 100
  wildcardPolicy: None
status:
  ingress:
  - conditions:
    - status: "True"
      type: Admitted

vi base/kustomization.yaml

- pacman-public-route.yaml
```
