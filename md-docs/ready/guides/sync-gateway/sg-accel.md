---
id: sg-accel
title: SG Accelerator
permalink: ready/guides/sync-gateway/sg-accel/index.html
---

Sync Gateway can be scaled horizontally (adding extra nodes to your Sync Gateway cluster) to handle large amounts of read traffic. However, there's a limit to how much write traffic a standard Sync Gateway cluster can handle. To support client replication (specifically the changes feed), Sync Gateway needs to monitor changes happening in the backing Couchbase Server bucket, apply security filtering, and stream those changes to users. To optimize this processing, Sync Gateway maintains an in-memory cache of recent changes in each channel, and uses that cache to serve _changes requests. However, each Sync Gateway node in the cluster needs to monitor the entire server mutation stream - as write throughput increases, each node needs to do more work to manage its cache.

Sync Gateway accel enables greater scalability by distributing the stream processing work across a cluster of sg-accel nodes. A cluster of sg-accel nodes work the server's mutation stream, and persist the channel information to a channel bucket. The cluster of Sync Gateway nodes are only responsible for serving client requests via the REST API. This makes it possible to scale both sg-accel and Sync Gateway horizontally to handle much larger write throughput.

## Basic Setup

### Setting up your Couchbase Server

Define a new bucket in your Couchbase Server - this is the bucket Sync Gateway accel will use to store channel information. These instructions will refer to this bucket as the "channel bucket", and the regular Sync Gateway bucket as the "data bucket". The sizing requirements for the channel bucket will vary depending on the size of your data bucket. (For 1.4 we'll be able to provide more detailed sizing recommendations)

### Setting up your Sync Gateway Accelerator cluster

1. Download and install sg_accel on the nodes in your Sync Gateway Accelerator cluster. You can download Sync Gateway from [Add-ons section](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile) or using rpm.
2. Next, you can specify the location of the channel bucket and of the data bucket in the Sync Gateway accel configuration file.

    ```javascript
    {
      "log": ["HTTP+"],
      "adminInterface": "127.0.0.1:4985",
      "interface": "0.0.0.0:4984",
      "cluster_config":{
        "server":"http://localhost:8091",
        "bucket":"default",
        "data_dir":"."
      },
      "databases": {
        "default": {
          "server": "http://localhost:8091",
          "bucket": "default",
          "channel_index": {
            "writer": true,
            "server":"http://localhost:8091",
            "bucket":"channel_bucket"
          }
        }
      }
    }
    ```

Some items to note:

- The `cluster_config` section is required to manage communication between your sg-accel nodes. The `server` property is your Couchbase Server address, and `bucket` is the name of your data bucket.
- The `default` database is the standard Sync Gateway database config, and the `server` and `bucket` should target your data bucket. The `channel_index` section specifies your channel bucket connection information. Start sg_accel on each node from the command line.

    ```bash
    sg_accel /path/to/sg-accel-config.json
    ```

### Setting up your sync_gateway cluster

1. Install sync_gateway on the nodes in your sync_gateway cluster.
2. Create a new file called `sync-gateway-config.json` to hold the configuration for Sync Gateway. On each node, customize your database config to add the channel_index property.

    ```javascript
    {
      "log": ["HTTP+"],
      "adminInterface": "127.0.0.1:4985",
      "interface": "0.0.0.0:4984",
      "databases": {
        "default": {
          "server": "http://localhost:8091",
          "bucket": "default",
          "channel_index": {
            "server":"http://localhost:8091",
            "bucket":"channel_bucket"
          }
        }
      }
    }
    ```

3. Start sg_accel on each node from the command line.

    ```bash
    sync_gateway /path/to/sync-gateway-config.json
    ```

### Configuring the number of shards

In the Sync Gateway config, `num_shards` represents the maximum number of concurrent sg_accel nodes that can be supported by the index, as in the maximum scenario each node would only receive one shard.

However, higher num_shards values also result in a more fragmented index, as entries in the index are grouped by shard. This means that a higher num_shards results in more work for index reads that scan all shards (e.g. large backfills, etc).

Based on this tradeoff, the default num_shards value should be reduced from 64 to 16 - this is a more appropriate value for accel users (max 16 accel nodes). Users who want to use a larger cluster can still set num_shards explicitly in the config.

Feedback:
- Capitalization of Sync Gateway accel. Sync Gateway accel vs sg-accel.
- "(For 1.4 we'll be able to provide more detailed sizing recommendations)"
- Command to install sg-accel through wget?
- Diagrams for with and without sg accel?