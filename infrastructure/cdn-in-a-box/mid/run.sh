#!/usr/bin/env bash

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

set -e
set -x
set -m

source /to-access.sh

source /to-access.sh

# Wait on SSL certificate generation
until [ -f "$CERT_DONE_FILE" ] 
do
  echo "Waiting on Shared SSL certificate generation"
  sleep 3
done

# Source the CIAB-CA shared SSL environment
source $CERT_ENV_FILE

# Trust the CIAB-CA at the System level
cp $CERT_CA_CERT_FILE /etc/pki/ca-trust/source/anchors
update-ca-trust extract

while ! to-ping 2>/dev/null; do
	echo "waiting for Traffic Ops"
	sleep 5
done

CDN=CDN-in-a-Box

export TO_USER=$TO_ADMIN_USER
export TO_PASSWORD=$TO_ADMIN_PASSWORD

# wait until the CDN has been registered
found=
while [[ -z $found ]]; do
    echo 'waiting for enroller setup'
    sleep 3
    found=$(to-get api/1.3/cdns?name="$CDN" | jq -r '.response[].name')
done

to-enroll mid $CDN || (while true; do echo "enroll failed."; sleep 3 ; done)

# Leaves the container hanging open in the event of a failure for debugging purposes
/opt/ort/traffic_ops_ort.py BADASS ALL "https://$TO_HOST:$TO_PORT" "$TO_ADMIN_USER:$TO_ADMIN_PASSWORD" || { echo "Failed"; tail -f /dev/null; }

tail -F /var/log/trafficserver/diags.log