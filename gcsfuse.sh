#!/usr/bin/env bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# [START cloudrun_fuse_script]
#!/usr/bin/env bash
set -eo pipefail

# Create mount directory for service
mkdir -p {$MNT_DIR_SOURCE,$MNT_DIR_PRODUCT,$GCSFUSE_LOG} 


gcloud auth activate-service-account $ACCOUNT_NAME \
    --key-file=$GOOGLE_APPLICATION_CREDENTIALS \
    --project=$PROJECT_ID

gcloud config set run/region us-east1

echo "Mounting GCS Fuse."

gcsfuse --log-file=$GCSFUSE_LOG/$BUCKET_SOURCE.log \
    --implicit-dirs --file-mode=0777 --dir-mode=0777 \
    $BUCKET_SOURCE $MNT_DIR_SOURCE 
    
gcsfuse --log-file=$GCSFUSE_LOG/$BUCKET_PRODUCT.log \
    --implicit-dirs --file-mode=0777 --dir-mode=0777 \
    $BUCKET_PRODUCT $MNT_DIR_PRODUCT

echo "Mounting completed."

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app &

# Exit immediately when one of the background processes terminate.
wait -n
# [END cloudrun_fuse_script]

# tail -n 20 -f $GCSFUSE_LOG/$BUCKET_SOURCE.log