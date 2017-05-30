---
title: Accelerator
---

In this guide, you will learn how to scale a Couchbase Mobile deployment with Sync Gateway Accelerator. Before going into the details, it's important to identify if you wish to scale the **read** or **write** throughput of your application's back-end infrastructure.

As a distributed database system, Sync Gateway and Couchbase Server can already be scaled horizontally. Horizontal scaling is achieved by adding more nodes behind a load balancer which distributes the traffic evenly between each one (see the [Install, Upgrade, Scale](../../../current/training/deploy/install/index.html) lesson). This method of scaling is particularly well suited for a scenario with a large amount of **read traffic**. On the other hand, it wouldn't suit a scenario where only the **write traffic** increases.

Sync Gateway Accelerator is designed to cover the second aspect of highly scalable server infrastructure for your application, **write traffic**.

## How does it work?

Part of Sync Gateway's role in a Couchbase Mobile deployment is to query the documents in a given channel from Couchbase Server and stream the results to users.

![](img/channel-access-accelerator.png)

To optimize this process, Sync Gateway maintains an in-memory cache of recent changes in each channel (step 3) which is used to serve the `GET/POST /{db}/_changes` requests (step 4). So as write throughput increases, the cache for a particular channel is invalidated more frequently and Sync Gateway needs to update its channel cache. Each Sync Gateway instance will end up doing this work to maintain the in-memory cache.

With Couchbase Mobile 1.4, it's now possible to build the set of documents per channel using a separate component called Sync Gateway Accelerator. This component can also be scaled horizontally and persists the channel index to a different bucket in Couchbase Server. In this configuration, the Sync Gateway nodes support your applications (Web, Mobile, IoT) as normal, while Sync Gateway Accelerator handles the channel indexing. Separating the two workloads in distinct entities makes it possible to scale both Sync Gateway and Sync Gateway Accelerator to handle much larger write throughput. The diagram below represents the architecture differences with and without Sync Gateway Accelerator.

![](img/accelerator-comparison.png)

## Example

Prior to installing Sync Gateway Accelerator you must have a running instance of Sync Gateway persisting documents to Couchbase Server. In this guide, we will assume the following components have already been configured, and for simplicity's sake are all running on the same host.

- A Couchbase Server cluster is up and running with a bucket called "data_bucket". A bucket cannot be renamed so if you already have a bucket with a different name that's ok. You'll have to replace it with your bucket name where applicable in the following steps of this section.

    ![](img/sg-accel-data-bucket.png)

    As you can see on this image, the bucket contains a few thousand documents that were added through the Sync Gateway
    REST API.

- A Sync Gateway instance persisting the documents to the data bucket with the following configuration file.

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

    Note that Sync Gateway Accelerator doesn't provide further scalability to deployments that use bucket shadowing. Bucket shadowing is being deprecated in 1.4 and will be removed in an upcoming version of Couchbase Mobile (2.x).

### Sync Gateway Accelerator

1. Download Sync Gateway Accelerator from the [Couchbase Downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).

    ![](img/downloads-add-ons.png)

2. Create a new bucket called "channel_bucket" in the Couchbase Server cluster.

    ![](img/sg-accel-create-bucket.png)

    ![](img/sg-accel-channel-bucket.png)

3. Next, create a new file called **accel-config.json**. That's where you must specify the location of the channel and data buckets.

    ```javascript
    {
      "log": ["HTTP+"],
      "adminInterface": ":4986",
      "cluster_config": {
        "server": "http://localhost:8091",
        "bucket": "data_bucket",
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

    In the configuration file, there are two points worth noting:
    - The default listening port for Sync Gateway Accelerator is `4985`. Here, you're setting it to `4986` to avoid using a port that conflicts with Sync Gateway.
    - The `"writer": true` property specifies that this Accelerator instance can persist the channel index to the Couchbase Server bucket.

4. Start the Sync Gateway Accelerator node.

    ```bash
    ~/Downloads/couchbase-sg-accel/bin/sg_accel accel-config.json
    ```

    Notice the document count is now increasing in `channel_bucket` because the channel index data is being stored there.

    ![](img/channel-bucket.png)

    To complete the installation, the Sync Gateway configuration file must be updated to reflect the new location of the channel index (i.e `channel_bucket`).

### Sync Gateway

Follow the steps below to update the Sync Gateway configuration file. It must be updated for every instance that was previously running without Sync Gateway Accelerator.

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

The installation of Sync Gateway with Accelerator is now complete. Couchbase Lite clients can continue replicating to the same endpoint as if nothing changed.

## Service Installers

You can download Sync Gateway Accelerator from the [Couchbase download page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile) or download it directly to a Linux system by using the `wget` or `curl` command.

```bash
wget {{ site.sg_download_link }}{{ site.sg_accel_package_name }}.deb
```

All download links follow the naming convention:

```bash
couchbase-sg-accel-community_<VERSION>-<BUILDNUM>_<ARCHITECTURE>.<EXT>
```

where

- `VERSION` is the release version.
- `BUILDNUM` is the specific build number.
- `ARCHITECTURE` is the target architecture of the installer.
- `EXT` is the file extension.

Once you have downloaded Sync Gateway Accelerator on the distribution of your choice you are ready to install and start it as a service.

### Ubuntu

Install sg_accel with the dpkg package manager e.g:

```bash
dpkg -i {{ site.sg_accel_package_name }}.deb
```

When the installation is complete sg_accel will be running as a service.

```bash
service sg_accel start
service sg_accel stop
```

The config file and logs are located in `/home/sg_accel`.

> **Note:** You can also run the **sg_accel** binary directly from the command line. The binary is installed at `/opt/couchbase-sg-accel/bin/sg_accel`.

### Red Hat/CentOS

Install sync_gateway with the rpm package manager e.g:

```bash
rpm -i {{ site.sg_accel_package_name }}.rpm
```

When the installation is complete sg_accel will be running as a service.

On CentOS 5:

```bash
service sg_accel start
service sg_accel stop
```

On CentOS 6:

```bash
initctl start sg_accel
initctl stop sg_accel
```

On CentOS 7:

```bash
systemctl start sg_accel
systemctl stop sg_accel
```

The config file and logs are located in `/home/sg_accel`.

### Debian

Install sg_accel with the dpkg package manager e.g:

```bash
dpkg -i {{ site.sg_accel_package_name }}.deb
```

When the installation is complete sync_gateway will be running as a service.

```bash
systemctl start sg_accel
systemctl stop sg_accel
```

The config file and logs are located in `/home/sg_accel`.

### Windows

Install sync_gateway on Windows by running the .exe file from the desktop.

```bash
{{ site.sg_accel_package_name }}.exe
```

When the installation is complete sg_accel will be installed as a service but not running.

Use the **Control Panel --> Admin Tools --> Services** to stop/start the service.

The config file and logs are located in ``.

## Configuration Reference

A configuration file determines the runtime behavior of Sync Gateway Accelerator. Using a configuration file is the recommended approach for configuring Sync Gateway Accelerator, because you can provide values for all configuration properties.

When specifying a configuration file, the command to run Sync Gateway Accelerator is:

```
$ sg_accel accel-config.json
```

<script>
	window.configurl = 'https://cb-mobile.s3.amazonaws.com/mobile/1.4/configs/sg-accel.json';
</script>
<div id="root"></div>