#!/bin/bash 

# Copyright 2015 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PATH=$PATH:/usr/pgsql-9.*/bin

# this lets us run initdb and postgres on Openshift
# when it is configured to use random UIDs
function ose_hack() {
        export USER_ID=$(id -u)
        export GROUP_ID=$(id -g)
        envsubst < /opt/cpm/conf/passwd.template > /tmp/passwd
        export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
        export NSS_WRAPPER_PASSWD=/tmp/passwd
        export NSS_WRAPPER_GROUP=/etc/group
}

id
ose_hack
id

echo $PATH is the path
export THISDIR=~/.pgadmin
if [ ! -f "$THISDIR/config_local.py" ]; then
	echo "WARNING: could not find mounted config files...using defaults as starting point"
	mkdir $THISDIR
	cp /opt/cpm/conf/config_local.py $THISDIR/
	cp /opt/cpm/conf/pgadmin4.db $THISDIR/
fi

cp $THISDIR/config_local.py /usr/lib/python2.7/site-packages/pgadmin4

python /usr/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py

while true; do
	echo "debug sleeping..."
	sleep 1000
done

