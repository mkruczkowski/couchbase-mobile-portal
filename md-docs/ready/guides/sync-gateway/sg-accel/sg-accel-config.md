---
id: sg-accel-config
title: Config
permalink: guides/sync-gateway/accelerator/config/index.html
---

You can specify the runtime behavior of a Sync Gateway Accelerator node in a configuration file. Most of the properties in the Sync Gateway configuration also apply to Sync Gateway Accelerator. There are two places in the configuration file that specific to a deployment that uses Sync Gateway Accelerator.

  - Cluster information
  - Channel index

The following configuration contains both of these.

```javascript
{
  "log": ["HTTP+"],
  "cluster_config": {
    "server": "http://localhost:8091",
    "bucket": "default",
    "data_dir": "."
  },
  "databases": {
    "app_name": {
      "server": "http://localhost:8091",
      "bucket": "data_bucket",
      "channel_index": {
        "writer": true,
        "server": "http://localhost:8091",
        "bucket": "channel_bucket"
      }
    }
  }
}
```

Let's take a look at each one in more detail.

## Cluster configuration

The `cluster_config` section is required to manage communication between your Sync Gateway Accelerator nodes. The `server` property is your Couchbase Server address, and `bucket` is the name of your data bucket.

|Property|Type|Description an default|
|:-------|:---|:---------------------|
|`server`|`string`|The hostname of the Couchbase Server cluster.|
|`bucket`|`string`|The bucket name where the data is stored (i.e the one specified in the database configuration.)|
|`data_dir`|`string`|Path to the data directory.|
|`heartbeat_interval_seconds`|`string`|TODO.|

## Channel index information

The `channel_index` section specifies your channel bucket connection information.

|Property|Type|Description and default|
|:-------|:---|:----------------------|
|`writer`|`boolean`|Whether the channel index node can write to the bucket.|
|`server`|`string`|Hostname to the Couchbase Server cluster.|
|`bucket`|`string`|Bucket name for channel indexing. A common name is "channel_index".|
