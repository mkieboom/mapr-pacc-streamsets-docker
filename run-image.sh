#!/bin/bash

# Create a folder to store the Streamsets pipelines outside of the container
SDC_DATA=sdc-data
mkdir $SDC_DATA

# Specify the container version tag. Versions available:
# streamsets352_mapr600_mep400
# streamsets352_mapr601_mep500
# streamsets360_mapr600_mep400
# streamsets360_mapr601_mep500
# streamsets372_mapr601_mep500
# streamsets381_mapr610_mep600 (latest)
CONTAINER_VERSION=streamsets381_mapr610_mep600

# Launch the Streamsets container based on MapR PACC
docker run -it \
--cap-add SYS_ADMIN \
--cap-add SYS_RESOURCE \
--device /dev/fuse \
-e MAPR_CLUSTER=demo.mapr.com \
-e MAPR_CLDB_HOSTS=192.168.1.11 \
-e MAPR_CONTAINER_USER=mapr \
-e MAPR_CONTAINER_GROUP=mapr \
-e MAPR_CONTAINER_UID=5000 \
-e MAPR_CONTAINER_GID=5000 \
-e MAPR_MOUNT_PATH=/mapr \
-v $PWD/sdc-data:/data \
-p 18630:18630 \
-v $PWD/mapr-ticket:/tmp/longlived_ticket:ro \
-e MAPR_TICKETFILE_LOCATION=/tmp/longlived_ticket \
mkieboom/mapr-pacc-streamsets-docker:$CONTAINER_VERSION

echo ""
echo "Streamsets pipelines persisted to: $PWD/$SDC_DATA"
echo ""
