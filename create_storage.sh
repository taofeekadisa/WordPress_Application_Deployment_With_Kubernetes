#!/bin/bash

#CREATE A STORAGE ACCOUNT OT STORE THE STATE FILES
rg_name="cohort3"
location="eastus2"
Owner="immersion"
Environment="dev"
Date_created="06-29-2023"
storage_account_name="capstone4321"
container_name="tfstate"
sku="Standard_LRS"
kind="BlobStorage"
encryption_services="blob"
allow_public_access="true"
public_access="blob"

#RESOURCE GROUP
az group create -n "$rg_name-rg-$Owner-$Environment" -l $location \
--tags Owner "$Owner" "Environment" "$Environment" Date_Created "$Date_Created"

#STORAGE ACCOUNT
az storage account create -n $storage_account_name -g "$rg_name-rg-$Owner-$Environment" \
-l $location --encryption-services blob --sku $sku \
--allow-blob-public-access $allow_public_access

#STORAGE CONTAINER
az storage container create -n $container_name --account-name $storage_account_name \
--public-access $public_access