---
title: Accelerator
---

## Sequence Handling

When using Sync Gateway Accelerator, Sync Gateway no longer uses a global sequence managed by Sync Gateway.  Instead, it uses Couchbase Server's vbucket sequences to identify what documents to send to clients.  There are two reasons for this change:
 
 - Incrementing the global sequence counter is a source of contention between Sync Gateway nodes.  As we scale to larger Sync Gateway clusters with higher overall write throughput, this contention would increase and be a throughput bottleneck.
 - Identifying contiguous sequence sets across multiple DCP processing nodes adds complexity and additional latency
 - Removing the global sequence dependency avoids complexity and latency associated with skipped/unused sequences  



### Sequence Handling Without Sync Gateway Accelerator
Sequence handling in a cluster without Sync Gateway Accelerator works the same as it does prior to 1.3.  Sync Gateway manages a global sequence number (using a counter document in its bucket), and assigns documents a sequence value at write time.  This sequence is used to order the changes feed.  Each Sync Gateway node monitors the full server mutation feed, and buffers that feed in order to rebuild an ordered set of documents.  

When sending entries on the changes feed, there are a few possible for formats for sequences:

Sample Sequence formats:
  
  - `100` :  Simple integer sequence (100)
  - `100:70` : Sequence 70, sent during a channel backfill triggered by sequence 100
  - `100::105` : Sequence 105, but Sync Gateway has only buffered sequences to 100 (skipped sequence handling)


### Sequence Handling With Sync Gateway Accelerator
In a cluster with Sync Gateway Accelerator, Sync Gateway no longer uses a global sequence.  Instead, documents are ordered based on the vbucket sequences assigned to the documents by Couchbase Server.  To identify their position in the changes feed, clients specify a vector clock of {vbucket, sequence} pairs, representing the latest sequence they've received in each vbucket.  
  e.g. {[0:5][1:3][2:25][3:0]...[1022:5][1023:23]}

The full vector clock is too large to send as a sequence value on a changes feed entry.  Instead, Sync Gateway hashes the vector clock and stores in a lookup table, and sends client a hash value that Sync Gateway can subsequently use to retrieve the full vector clock.

This doesn't require any client changes (Couchbase Lite or otherwise), as the sequence value has always been defined as an opaque string.  Client behaviour doesn't change - they issue a changes request and receive a set of changes and a `last_seq` value in response.  Subsequent changes requests send that `last_seq` value as the `since` value on a subsequent changes request.

Because calculating and storing the hashed clock is relatively expensive, not every entry in the changes feed response is allocated a new hash value.  Hash values are calculated as needed, based on the following rules:
 - A new hash is always calculated for `last_seq`
 - A new hash is always calculated for channel backfill triggers
 - For a continuous changes feed, a new hash is calculated for every 50th entry.

Sample sequence formats:
  - `3-0` : Simple sequence clock hash.  
  - `3-0:14.253` : Entry with vb:14, vbseq:253, sent during a channel backfill triggered by sequence clock with hash `3-0`
  - `3-0::14.253` : Entry with vb:14, vbseq:253, sent as intermediary (non-hashed) sequence.
 

### Support Notes - Sequence Handling

 - Global sequence values aren't supported when running with SG Accel, and hashed sequence values aren't supported when running without SG Accel.  Looking at the format of sequence values can be a quick way to identify a mis-configured environment.
 
## Cluster node management

The set of nodes in the Sync Gateway Accel cluster is stored in the cluster_config bucket, in the file _sync:cfg.

### Added node detection

When a Sync Gateway Accel node comes online, it registers in the config. This triggers an update to the _sync:cfg to reshard the vbuckets to include the new node.

### Removed node detection

Active nodes update a heartbeat document in the cluster_config bucket (every 10 seconds, by default). Each Sync Gateway Accel node monitors the heartbeat documents for nodes specified in the _sync:cfg. When a Sync Gateway Accel node goes offline (stops sending heartbeats), one of the other Sync Gateway Accel nodes will detect this and remove it from the cluster config (triggering resharding of vbuckets to the remaining nodes).

There is no direct communication between Sync Gateway Accel nodes - all interaction is done through the cluster_config bucket. As a result, there isn't any additional handling required for network partitions between Sync Gateway Accel nodes - everything is based on communication with the backing Couchbase Server.

## Cluster deployment

### Sync Gateway

There isn't any change in cluster management from previous releases for Sync Gateway nodes.

- Sync Gateway nodes are normally internet-facing, serving HTTP requests from clients
- A cluster of Sync Gateway nodes would typically be deployed behind a load balancer
- Adding or removing nodes is just a matter of spinning up the node, and updating the set of target nodes in the load balancer.

### Sync Gateway Accelerator

Sync Gateway Accel nodes have the following differences:

- Sync Gateway Accelerator nodes do not need to be internet-facing - end users don't access the SG Accel nodes
- When Sync Gateway Accel nodes are added or removed from the cluster, the DCP stream is automatically resharded across the updated set of nodes.

### Cluster Sizing

We don't have detailed sizing requirements/recommendations at this point (it's on the post-1.4 roadmap!). However, some general comments/recommendations can be made:

- Typically there wouldn't be a reason to deploy less than two Sync Gateway Accel nodes in a cluster. Running a single node would mean the entire DCP feed is being processed by a single node, which isn't that different than Sync Gateway running without SGA. There are some other aspects to consider (you could scale up a single SGA node and scale out the SG cluster), but generally speaking 2 nodes of SGA would be the minimum deployment.
- Adding more Sync Gateway nodes allows the cluster to handle more concurrent users, for both read and write operations. When the Sync Gateway cluster is overloaded, all operations tend to slow down.
- Adding more Sync Gateway Accelerator nodes allows the cluster to handle more write throughput. When the Sync Gateway Accel nodes are overloaded, changes feed latency (and by extension, how long it takes clients to see updates) will increase, as the Accel nodes struggle to keep up with Couchbase Server's DCP feed.
