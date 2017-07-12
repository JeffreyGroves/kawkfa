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

curBrokerID=$2
if [ $curBrokerID == "" ]
then
   echo "Usage: $0 dumpfile broker.id"
   exit
fi
inFile=$1
if [ -f $infile ]
then
 awk -F"[ \t,]" 'BEGIN { brokerID='"${curBrokerID}"'
                 #print "{\"partitions\": [" 
                 } 
                 /Topic: / { 
                  if (NF < 13) {}
                  if (NF < 14 && $12 == "Isr:"  && ( $9 == brokerID || $10 == brokerID || $11 == brokerID) )  {
                         if ($7 == $13)  {
                               first=$13
                              } 
                         printf ("{\"topic\": \"%s\", \"partition\": %s, \"replicas\": [%s,"brokerID"]},\n", $3, $5, first)
                         }
                  else if (NF < 15 && $12 == "Isr:" && ( $9 == brokerID || $10 == brokerID || $11 == brokerID) ) {
                         if ($7 == $14)  {
                               first=$14
                               second=$13
                              }
                         else if ($7 == $13) {
                               first = $13
                               second=$14
                              }
                         printf ("{\"topic\": \"%s\", \"partition\": %s, \"replicas\": [%s,%s,"brokerID"]},\n", $3, $5, first,second)
                         }
                  else if (NF < 16 && $12 == "Isr:" && ( $9 == brokerID || $10 == brokerID || $11 == brokerID) ) {
                         if ($9 == brokerID ) {
                            first=$10
                            second=$11
                            third=$9
                         }
                         else if ($10 == brokerID ) {
                            first=$9
                            second=$11
                            third=$10
                         }
                         else if ($11 == brokerID ) {
                            first=$9
                            second=$10
                            third=$11
                         }
                         printf ("{\"topic\": \"%s\", \"partition\": %s, \"replicas\": [%s,%s,%s]},\n", $3, $5, first,second,third)
                         }
                   }
                   END { 
                           #print "  ],\n  \"version\":1\n}" 
                        }' $inFile 
else
   echo "$inFile does not exist"
   echo "Usage: $0 dumpfile broker.id"
fi
