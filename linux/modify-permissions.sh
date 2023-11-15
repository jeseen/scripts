#!/bin/bash

# Script to chmod the Terraform state files. By default only the person that executes the initial 'terraform apply', has permissions to the directories and files created by Terraforml

ROOT_DIRECTORIES=(
  "/terraform/state/user-sb01"
  "/terraform/state/mgmt-sb01"
)

for rootdirectory in ${ROOT_DIRECTORIES[@]}
do
  echo "Changing permissions for directory [$rootdirectory] and all subdirectories to 770"
  find $rootdirectory -type d -exec chmod -R 770 {} \;
  echo "Changing permissions to files within [$rootdirectory] and in all subfolders to 660"
  find $rootdirectory -type f -exec chmod -R 660 {} \;
done


