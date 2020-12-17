#!/bin/bash -x
# Tzahi Ariel 2020

# Checking Prerequisites
echo "AZ CLI needs to be at least 2.0.71"
az --version
echo ""
echo "Getting Helm 3:"
sleep 1
# Getting helm 3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh
./get_helm.sh
echo "helm needs to be at least 3.1.0"
helm version
echo ""
echo "Did u fill the VARS in the script manually? (if not then exit and edit)"
sleep 1
echo ""
echo "Do u want to continue? (y/n)"
read CH
if [[ $CH != "y" ]]
then
    exit 1
fi

# Defining VARS:
# Constant VAR
export HELM_EXPERIMENTAL_OCI=1

# Variables ### CHANGE HERE ###

REG='XXXX.azurecr.io'
SPID='<SERVICE-PRINCIPLE-ID>'
PASS='<SERVICE-PRINCIPLE-PASSWORD>'

###

# Prepearing the working space:
mkdir nginx-chart
cd nginx-chart
helm create hello-world-nginx


## Adding the nginx-deployment to the templates
cd hello-world-nginx/templates
rm -rf *
cd ../../../
mv deployment-nginx.yml nginx-chart/hello-world-nginx/templates/


## Saving the Chart to local reg for Caching
helm chart save . nginx-deployment:latest
## Saving for push command
helm chart save . $REG/helm/nginx-deployment:latest

## To confirm saved charts
helm chart list

## Auth with reg
echo $PASS | helm registry login $REG --username $SPID --password-stdin


## Push to reg
helm chart push $REG/helm/nginx-deployment:latest


## Verify push with
az acr repository show --name $REG --repository helm/nginx-deployment
az acr repository show-manifests --name $REG --repository helm/nginx-deployment --detail