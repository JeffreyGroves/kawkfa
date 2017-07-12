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

inFile=$1
curBrokerID=$2
if [ "$curBrokerID" == "" ]
then
   echo "Usage: $0 dumpfile broker.id"
   exit
fi
if [ -f $inFile ]
then
 lenInFile="$(wc -l $inFile | awk '{print $1}')"
 gawk -F"[ \t,]" 'function randint(n) {
                    return int(n * rand())
                 }
                 BEGIN { brokerID='$curBrokerID'
                    srand()
                    lenInFile='$lenInFile'
                    bailOut="N"
                    print "{\"partitions\": [" 
                 } 
                 /Topic: / { 
                  if ( NF < 15 && bailOut == "N" ) { 
                     printf ("\n\n\n\n\n\nError!  Not all Partitions are ready for normaliation!  Fix Isr and/or missing replicas issues first!\n\n\nBailing Out!\n\n")
                     bailOut="Y"
                  }
                  else if (NF < 16 && $12 == "Isr:" &&  $11 == brokerID  && bailOut == "N" )  {
                     randNum = randint(3)
                     if (randNum  == 0) {
                         first = $9
                         second = $10
                         third = $11
                      }
                      else if (randNum == 1 ) {
                         first = $10
                         second = $11
                         third = $9
                      }
                      else if (randNum == 2 ) {
                         first = $11
                         second = $9
                         third = $10
                      }
                      printf ("{\"topic\": \"%s\", \"partition\": %s, \"replicas\": [%s,%s,%s]},\n", $3, $5, first, second, third)
                   }
                   }
                   END { if ( bailOut == "N") { 
                            print "  ],\n  \"version\":1\n}" 
                         } 
                       }' $inFile 
else
   echo "$inFile does not exist"
   echo "Usage: $0 dumpfile broker.id"
fi
