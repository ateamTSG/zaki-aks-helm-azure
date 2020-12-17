#!/bin/bash
# Dec 2020 Tzahi

# IMPORTANT!
## To install a Helm chart to Kubernetes, the chart must be in the LOCAL cache!!

## Change Registry VAR!
REG='XXX.azurecr.io'
RELEASE_NAME='nginx-helloworld'
# Making sure it doesn't deploy from local source from before script
helm chart remove $REG/helm/nginx-deployment:latest

## Pulling from Registry to local:
helm chart pull $REG/helm/nginx-deployment:latest

## Exporting the pulled chart:
helm chart export $REG/helm/nginx-deployment:latest --destination ./install
cd install

## Deploying
helm install $RELEASE_NAME ./nginx-deployment

## Verify
helm get manifest $RELEASE_NAME

echo ""
echo "helm chart is deployed on the cluster"
echo "IF u with to remove it enter: helm uninstall $RELEASE_NAME"
echo "If u wish to remove it from ACR run: az acr repository delete --name $REG --image helm/nginx-deployment:latest"
