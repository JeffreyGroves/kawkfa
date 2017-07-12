#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cd ~kafka
zooKList=$1
if [ "$zooKList" == "" ]
then
  echo Usage $0 <zookeeper-host:2181> <reassign-json-file>
  exit 1
fi
jsonFile=$2
if [ "$jsonFile" == "" ]
then
   echo Usage $0 <zookeeper-host:2181> <reassign-json-file>
   exit 1
fi
if [ -f $jsonFile ]
then
   kafka-reassign-partitions.sh --zookeeper ${zooKList} --reassignment-json-file $1 --execute  > ${jsonFile}.rollback 2>&1
   grep -q 'Successfully started reassignment of partitions' ${jsonFile}.rollback
   resultCode=$?
   if [ $resultCode -eq 0 ]
   then
      tail -15 $jsonFile
      mv $jsonFile done/
   else
      echo "ERROR: reassignment operation failed"
   fi
else 
   echo "File not found: $jsonFile"
fi
