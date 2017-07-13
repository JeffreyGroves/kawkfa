# kawkfa
AWK scripts to slice and dice Kafka partition listings into almost usable JSON files.


This is a series of awk scripts that create json files for managing removal and addition of Kafka brokers back to a cluster in a controlled
manner.

The gist:
```
Create a file with all of the topics and partitions using dump-partitions.sh
Create a json file to remove the broker that is to be shutdown  using the file created by dump-partitions.sh with the kawkfa-pre-shutdown.sh
script redirecting the output to file file
Run that json file using the doReassign.sh script on your Kafka cluster.  This will remove all partition replica from the broker in question
shut down the broker in question and do whatever it is you need to do with it
start up the broker after you're done working on it
Create a json file to add back to the broker the partitions that you removed above by using the file created by dump-partitions.sh with the
kawka-post-startup.sh script and rediret the output to a file
Run the json file using the doReassign.sh script on you Kafka cluster.  This will add back the partitions that were previously on this node
but add it back as the last entry in the replicas list.  We don't want this broker to be the Leader of any partitions just yet.
Create a json file to randomize the preferred replica for each partition using the file created by the dump-partitions.sh with the kawka-normalize.sh script.
Run the json file using the doReassign.sh script on you Kafka cluster.  This will randomize the broker that is the preferred broker for those partitions that involve the broker that was just returned to the cluster.
```

This is just a rough description of the use of these scripts.

These scripts probably only work in situation where replication factor for all topics is 3.  

