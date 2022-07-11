# Cloud Run File System Sample
This sample shows how to create a service that mounts a gsfuse in a docker application

## Documentation
Cloud Storage FUSE is an open source FUSE adapter that allows you to mount Cloud Storage buckets as file systems on Linux or macOS systems. It also provides a way for applications to upload and download Cloud Storage objects using standard file system semantics. Cloud Storage FUSE can be run anywhere with connectivity to Cloud Storage, including Google Compute Engine VMs or on-premises systems.

### Requirements
    - install [docker] and [docker compose]
    - Configure [gcloud]: The gcloud command-line interface is the primary CLI tool to create and manage Google Cloud resources.
    - Generate [Service Account]: gcloud auth activate-service-account serves the same function as gcloud auth login but uses a service account rather than Google user credentials.  

### Run on local
```shell script
    docker-compose up --build 
    docker exec -it docker-gfuse_gfuse_1 /bin/bash
    
    # List Data
    ls /mnt/source
    ls /mnt/source
```

[docker]: https://docs.docker.com/engine/install/
[docker compose]: https://docs.docker.com/compose/install/
[Service Account]: https://cloud.google.com/iam/docs/creating-managing-service-accounts