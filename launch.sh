#!/bin/bash

# Check if the /mapr/clustername mountpoint is available
if [ "$(sudo ls /mapr/ |wc -l)" -eq 0 ]; then
  echo "MapR mountpoint not available. Check cluster config. Exiting now."
  exit
else
  # Echo config
  echo "MapR cluster successfully mounted in /mapr."
  echo "Launching Streamsets with following configuration:"
  echo ""
  echo "SDC_HOME:	$SDC_HOME"
  echo "SDC_DIST:	$SDC_DIST"
  echo "SDC_CONF:	$SDC_CONF"
  echo "MAPR_VERSION:	$MAPR_VERSION"
  echo "MAPR_MEP_VERSION:$MAPR_MEP_VERSION"
  echo "MAPR_HOME:	$MAPR_HOME"
  echo ""

  #sudo -E $SDC_DIST/bin/streamsets stagelibs -install=$STREAMSETS_STAGELIBS
  #sudo -E $SDC_DIST/bin/streamsets setup-mapr

  # launch Streamsets as the SDC_USER
  sudo -E -u $SDC_USER $SDC_DIST/bin/streamsets dc
fi