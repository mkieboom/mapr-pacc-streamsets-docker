# mapr-pacc-streamsets-docker

#### Disclaimer
Not for production use and not officially supported by MapR Technologies.

#### Introduction
MapR Persistent Application Client Container (PACC) running StreamSets DataCollector (SDC). This pre-build container running StreamSets allows you to launch pipelines against a MapR cluster immediately.

#### Pre-requisites
A MapR cluster and Docker.

#### Running the container
Modify the 'run-image.sh' script to reflect your MapR cluster configuration.
```
vi run-image.sh
bash run-image.sh
```

For a list of available container versions please visit:
https://hub.docker.com/r/mkieboom/mapr-pacc-streamsets-docker/tags/

#### Pre-Installed StreamSets Stage Libraries
The container comes with the following Stage Libraries pre-installed:

StreamSets Stage Libraries for MapR:
```
streamsets-datacollector-mapr_6_0-lib
streamsets-datacollector-mapr_6_0-mep4-lib
```

StreamSets Stage Libraries for generic:
```
streamsets-datacollector-dataformats-lib
streamsets-datacollector-jdbc-lib
streamsets-datacollector-jython_2_7-lib
```

StreamSets Stage Libraries for Cloud Providers:
```
streamsets-datacollector-google-cloud-lib
streamsets-datacollector-aws-lib
streamsets-datacollector-azure-lib
```

To add additional stage libraries, add them to the Dockerfile. For a complete list of StreamSets Stage Libraries please visit:
https://streamsets.com/documentation/datacollector/latest/help/datacollector/UserGuide/Installation/AddtionalStageLibs.html#concept_evs_xkm_s5

##### Clone the project
```
git clone https://github.com/mkieboom/mapr-pacc-streamsets-docker
cd mapr-pacc-streamsets-docker
```

#### Build the container
```
bash build-image.sh
```
