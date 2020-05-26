# Define the `NAMESPACE` variable
NAMESPACE=mongo
# Define the `SERVICE_NAME` variable
SERVICE_NAME=mongo
# Define the variable of `ROUTE_CLUSTER1`
ROUTE_CLUSTER1=mongo-cluster1.$(oc --context=east1 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Define the variable of `ROUTE_CLUSTER2`
ROUTE_CLUSTER2=mongo-cluster2.$(oc --context=east2 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Define the variable of `ROUTE_CLUSTER3`
ROUTE_CLUSTER3=mongo-cluster3.$(oc --context=west2 get ingresses.config.openshift.io cluster -o jsonpath='{ .spec.domain }')
# Define the variable of `SAN`
SANS="localhost,localhost.localdomain,127.0.0.1,${ROUTE_CLUSTER1},${ROUTE_CLUSTER2},${ROUTE_CLUSTER3},${SERVICE_NAME},${SERVICE_NAME}.${NAMESPACE},${SERVICE_NAME}.${NAMESPACE}.svc.cluster.local"
