#!/bin/fish

set -x YC_TOKEN (yc iam create-token)
set -x YC_CLOUD_ID (yc config get cloud-id)
set -x YC_FOLDER_ID (yc config get folder-id)
set -x TF_VAR_yc_folder_id $YC_FOLDER_ID
