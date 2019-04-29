#
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#

FROM maprtech/pacc:6.1.0_6.0.0_centos7

MAINTAINER mkieboom at mapr.com
# Based on the original version by Paul Curtis <pcurtis@mapr.com>

# MapR variables
ENV MAPR_VERSION=6.1.0 \
    MAPR_MEP_VERSION=6 \
    MAPR_HOME=/opt/mapr/

# Streamsets variables
ENV STREAMSETS_VERSION=3.8.1

# Streamsets Stagelibs
ENV STREAMSETS_LIBS_MAPR=${STREAMSETS_LIBS_MAPR},streamsets-datacollector-mapr_6_1-lib
ENV STREAMSETS_LIBS_MAPR=${STREAMSETS_LIBS_MAPR},streamsets-datacollector-mapr_6_1-mep6-lib

ENV STREAMSETS_LIBS_CORE=${STREAMSETS_LIBS_CORE},streamsets-datacollector-dataformats-lib
ENV STREAMSETS_LIBS_CORE=${STREAMSETS_LIBS_CORE},streamsets-datacollector-jdbc-lib
ENV STREAMSETS_LIBS_CORE=${STREAMSETS_LIBS_CORE},streamsets-datacollector-jython_2_7-lib

ENV STREAMSETS_LIBS_CLOUD=${STREAMSETS_LIBS_CLOUD},streamsets-datacollector-google-cloud-lib
ENV STREAMSETS_LIBS_CLOUD=${STREAMSETS_LIBS_CLOUD},streamsets-datacollector-aws-lib
ENV STREAMSETS_LIBS_CLOUD=${STREAMSETS_LIBS_CLOUD},streamsets-datacollector-azure-lib

ENV STREAMSETS_STAGELIBS=${STREAMSETS_LIBS_MAPR},${STREAMSETS_LIBS_CORE},${STREAMSETS_LIBS_CLOUD}


ENV SDC_USER=sdc
ENV SDC_URL=https://archives.streamsets.com/datacollector/${STREAMSETS_VERSION}/tarball/streamsets-datacollector-core-${STREAMSETS_VERSION}.tgz

# The paths below should generally be attached to a VOLUME for persistence.
# SDC_CONF is where configuration files are stored. This can be shared.
# SDC_DATA is a volume for storing collector state. Do not share this between containers.
# SDC_LOG is an optional volume for file based logs.
# SDC_RESOURCES is where resource files such as runtime:conf resources and Hadoop configuration can be placed.
# STREAMSETS_LIBRARIES_EXTRA_DIR is where extra libraries such as JDBC drivers should go.
ENV SDC_CONF=/etc/sdc/ \
    SDC_DATA=/data/ \
    SDC_DIST="/opt/streamsets-datacollector-${STREAMSETS_VERSION}/" \
    SDC_HOME="/opt/streamsets-datacollector-${STREAMSETS_VERSION}/" \
    SDC_LOG=/logs/ \
    SDC_RESOURCES=/resources
ENV STREAMSETS_LIBRARIES_EXTRA_DIR="${SDC_DIST}/streamsets-libs-extras"

RUN groupadd --system ${SDC_USER} && \
    adduser --system -g ${SDC_USER} ${SDC_USER}

RUN cd /tmp && \
    curl -o /tmp/sdc.tgz -L "${SDC_URL}" && \
    mkdir ${SDC_DIST} && \
    tar xzf /tmp/sdc.tgz --strip-components 1 -C ${SDC_DIST} && \
    rm -rf /tmp/sdc.tgz

# Add logging to stdout to make logs visible through `docker logs`.
RUN sed -i 's|INFO, streamsets|INFO, streamsets,stdout|' "${SDC_DIST}/etc/sdc-log4j.properties"

# Create necessary directories.
RUN mkdir -p /mnt \
    "${SDC_DATA}" \
    "${SDC_LOG}" \
    "${SDC_RESOURCES}"

# Move configuration to /etc/sdc
RUN mv "${SDC_DIST}/etc" "${SDC_CONF}"

# Use short option -s as long option --status is not supported on alpine linux.
# RUN sed -i 's|--status|-s|' "${SDC_DIST}/libexec/_stagelibs"

# Setup filesystem permissions.
RUN chown -R "${SDC_USER}:${SDC_USER}" "${SDC_DIST}/streamsets-libs" \
    "${SDC_CONF}" \
    "${SDC_DATA}" \
    "${SDC_LOG}" \
    "${SDC_RESOURCES}" \
    "${STREAMSETS_LIBRARIES_EXTRA_DIR}"

# Install the MapR library
RUN sudo -E ${SDC_DIST}/bin/streamsets stagelibs -install=${STREAMSETS_STAGELIBS}

# Run Streamsets mapr-setup
RUN sudo -E ${SDC_DIST}/bin/streamsets setup-mapr

# Expose the Streamsets port
EXPOSE 18630

# Add the launch script which checks if the /mapr mountpoint is available in the container
ADD launch.sh /launch.sh
RUN sudo chmod +x /launch.sh

CMD /launch.sh
