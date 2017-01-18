---
id: sg-accel-example
title: Example
permalink: guides/sync-gateway/accelerator/example/index.html
---

In this guide, we will setup a Sync Gateway and Sync Gateway Accelerator with the basic configurations.

## Prerequisites

Prior to installing Sync Gateway Accelerator you must have a running instance of Sync Gateway persisting documents to Couchbase Server. We will assume the following components have already been configured.

- A Couchbase Server cluster is up and running with a bucket called "data_bucket". A bucket cannot be renamed so if you already have a bucket with a different name that's ok. You'll have to make sure to write down the correct name in the following steps of this guide.

    ![](img/sg-accel-data-bucket.png)

    This bucket contains a few thousand documents that were added through the Sync Gateway REST API.

- A Sync Gateway instance persisting the documents to the data bucket.

    ```javascript
    {
      "log": ["HTTP+"],
      "databases": {
        "app_name": {
          "server": "http://localhost:8091",
          "bucket": "data_bucket"
        }
      }
    }
    ```

    Again, if you are following this guide with an existing system already running, your configuration may differ slightly.

## Installing Sync Gateway Accelerator

1. Download Sync Gateway Accelerator from the [Couchbase Downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).

    ![](img/downloads-add-ons.png)

2. Create a new bucket called "channel_bucket" in the Couchbase Server cluster.

    ![](img/sg-accel-channel-bucket.png)

3. Next, create a new file called **accel-config.json**. That's where you must specify the location of the channel and data buckets.

    ```javascript
    {
      "log": ["HTTP+"],
      "cluster_config":{
        "server":"http://localhost:8091",
        "bucket":"data_bucket",
        "data_dir":"."
      },
      "databases": {
        "app_name": {
          "server": "http://localhost:8091",
          "bucket": "data_bucket",
          "channel_index": {
            "writer": true,
            "server":"http://localhost:8091",
            "bucket":"channel_bucket"
          }
        }
      }
    }
    ```

4. Start the Sync Gateway Accelerator node.

    ```bash
    ~/Downloads/couchbase-sg-accel/bin/sync_gateway accel-config.json
    ```

    Notice the document count is now increasing in the `channel_bucket` because the channel index is being stored there instead of in the data bucket.

## Sync Gateway

The Sync Gateway configuration must be updated with the information regarding the location of the channel index.

1. Update your **sync-gateway-config.json** with the following.

    ```javascript
    {
      "log": ["HTTP+"],
      "databases": {
        "app_name": {
          "server": "http://localhost:8091",
          "bucket": "data_bucket",
          "channel_index": {
            "server": "http://localhost:8091",
            "bucket": "channel_bucket"
          }
        }
      }
    }
    ```

2. Restart Sync Gateway with the updated configuration file.

    ```bash
    ~/Downloads/couchbase-sync-gateway/bin/sync_gateway sync-gateway-config.json
    ```

## Verifying the installation

You will insert 100 documents through the REST API. If they are outputted in the changes feed then it means the installation was successful.
