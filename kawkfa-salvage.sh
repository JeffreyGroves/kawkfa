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

addBrokers=$2
if [ "$addBrokers" == "" ]
then
   echo "Usage: $0 dumpfile broker.id"
   exit
fi
inFile=$1
if [ -f $infile ]
then
 awk -F"[ \t,]" 'BEGIN { newBrokers="'$addBrokers'"
                 print "{\"partitions\": [" } 
                 /Topic: / { 
                  if (NF < 12 && $10 == "Isr:" ) {
                         first=$7
                         printf ("{\"topic\": \"%s\", \"partition\": %s, \"replicas\": [%s,%s]},\n", $3, $5, first, newBrokers)
                         }
                  if (NF < 14 && $12 == "Isr:"  )  {
                         first=$7
                         printf ("{\"topic\": \"%s\", \"partition\": %s, \"replicas\": [%s,%s]},\n", $3, $5, first, newBrokers)
                         }
                   }
                   END { print "  ],\n  \"version\":1\n}" }' $inFile 
else
   echo "$inFile does not exist"
   echo "Usage: $0 dumpfile broker.id"
fi
