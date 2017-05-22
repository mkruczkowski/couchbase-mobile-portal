---
id: sg
title: Sync Gateway
permalink: installation/sync-gateway/index.html
---

You can download Sync Gateway from the [Couchbase downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile) or download it directly to a Linux system by using the `wget`.

```bash
wget {{ site.sg_download_link }}{{ site.sg_package_name }}.deb
```

All download links follow the naming convention:

```bash
couchbase-sync-gateway-community_<VERSION>-<BUILDNUM>_<ARCHITECTURE>.<EXT>
```

where

- `VERSION` is the release version.
- `BUILDNUM` is the specific build number.
- `ARCHITECTURE` is the target architecture of the installer.
- `EXT` is the file extension.

## Requirements

|Ubuntu|CentOS/RedHat|Debian|Windows|macOS|
|:-----|:------------|:-----|:------|:----|
|12, 14|5, 6, 7|8|Windows 8, Windows 10, Windows Server 2012|Yosemite, El Capitan|

### Network configuration

Sync Gateway uses specific ports for communication with the outside world, mostly Couchbase Lite databases replicating to and from Sync Gateway. The following table lists the ports used for different types of Sync Gateway network communication:

|Port|Description|
|:---|:----------|
|4984|Public port. External HTTP port used for replication with Couchbase Lite databases and other applications accessing the REST API on the Internet.|
|4985|Admin port. Internal HTTP port for unrestricted access to the database and to run administrative tasks.|

Once you have downloaded Sync Gateway on the distribution of your choice you are ready to install and start it as a service.

### Compatibility with Couchbase Server

|CB/Sync Gateway|SG 1.2.1|SG 1.3.1|SG 1.4.1|
|:--------------|:-----|:------|:-----|:-----|
|CB 4.0|✔|✔|✔|✔|
|CB 4.1|✔|✔|✔|✔|
|CB 4.5|✔|✔|✔|✔|
|CB 4.6|✔|✔|✔|✔|

## Installation

### Ubuntu

Install sync_gateway with the dpkg package manager e.g:

```bash
dpkg -i {{ site.sg_package_name }}.deb
```

When the installation is complete sync_gateway will be running as a service.

```bash
service sync_gateway start
service sync_gateway stop
```

The config file and logs are located in `/home/sync_gateway`.

> **Note:** You can also run the **sync_gateway** binary directly from the command line. The binary is installed at `/opt/couchbase-sync-gateway/bin/sync_gateway`.

### Red Hat/CentOS

Install sync_gateway with the rpm package manager e.g:

```bash
rpm -i {{ site.sg_package_name }}.rpm
```

When the installation is complete sync_gateway will be running as a service.

On CentOS 5:

```bash
service sync_gateway start
service sync_gateway stop
```

On CentOS 6:

```bash
initctl start sync_gateway
initctl stop sync_gateway
```

On CentOS 7:

```bash
systemctl start sync_gateway
systemctl stop sync_gateway
```

The config file and logs are located in `/home/sync_gateway`.

### Debian

Install sync_gateway with the dpkg package manager e.g:

```bash
dpkg -i {{ site.sg_package_name }}.deb
```

When the installation is complete sync_gateway will be running as a service.

```bash
systemctl start sync_gateway
systemctl stop sync_gateway
```

The config file and logs are located in `/home/sync_gateway`.

### Windows

Install sync_gateway on Windows by running the .exe file from the desktop.

```bash
{{ site.sg_package_name }}.exe
```

When the installation is complete sync_gateway will be installed as a service but not running.

Use the **Control Panel --> Admin Tools --> Services** to stop/start the service.

The config file and logs are located in ``.

### macOS

Download the **tar.gz** file using `wget` or `curl`.

```bash
wget {{ site.sg_download_link }}{{ site.sg_package_name }}.tar.gz
```

Install sync_gateway by unpacking the tar.gz installer.

```bash
sudo tar -zxvf {{ site.sg_package_name }}.tar.gz --directory /opt
```

Create the sync_gateway service.

```bash
$ sudo mkdir /Users/sync_gateway

$ cd /opt/couchbase-sync-gateway/service

$ sudo ./sync_gateway_service_install.sh
```

To restart sync_gateway (it will automatically start again).

```bash
$ sudo launchctl stop sync_gateway
```

To remove the service.

```bash
$ sudo launchctl unload /Library/LaunchDaemons/com.couchbase.mobile.sync_gateway.plist
```

The config file and logs are located in `/Users/sync_gateway`.

### Walrus mode

By default, Sync Gateway uses a built-in, in-memory server called "Walrus" that can withstand most prototyping use cases, extending support to at most one or two users. In a staging or production environment, you must connect each Sync Gateway instance to a Couchbase Server cluster.

### Connecting to Couchbase Server

To connect Sync Gateway to Couchbase Server:

- [Download](https://www.couchbase.com/nosql-databases/downloads) and install Couchbase Server.
- Open the Couchbase Server Admin Console on [http://localhost:8091](http://localhost:8091) and log on using your 
administrator credentials.
- In the toolbar, select the **Data Buckets** tab and click the **Create New Data Bucket** button.
		![](../img/cb-create-bucket.png)
- Provide a bucket name, for example **mobile_bucket**, and leave the other options to their defaults.
- Specify the bucket name and Couchbase Server host name in the Sync Gateway configuration.

	```javascript
	{
		"log": ["*"],
		"databases": {
			"db": {
				"server": "http://localhost:8091",
				"bucket": "mobile_bucket",
				"users": { "GUEST": { "disabled": false, "admin_channels": ["*"] } }
			}
		}
	}
	```

> **Note:** Do not add, modify or remove data in the bucket using Couchbase Server SDKs or the Admin Console, or you will confuse Sync Gateway. To modify documents, we recommend you use the Sync Gateway's REST API.

### Couchbase Server network configuration

In a typical mobile deployment on premise or in the cloud (AWS, RedHat etc), the following ports must be opened on the host for Couchbase Server to operate correctly: 8091, 8092, 8093, 8094, 11207, 11210, 11211, 18091, 18092, 18093. You must verify that any firewall configuration allows communication on the specified ports. If this is not done, the Couchbase Server node can experience difficulty joining a cluster. You can refer to the [Couchbase Server Network Configuration](/documentation/server/current/install/install-ports.html) guide to see the full list of available ports and their associated services.

## Getting Started

Before installing Sync Gateway, you should have completed the Getting Started instructions for Couchbase Lite on the platform of [your choice](../index.html) (iOS, Android, .NET, Xamarin, Java or PhoneGap). To begin synchronizing between Couchbase Lite and Sync Gateway follow the steps below:

1. Configure Sync Gateway to use the following configuration file.

	```json
	{
		"databases": {
			"hello": {
				"server": "walrus:",
				"users": {"GUEST": {"disabled": false, "admin_channels": ["*"]}},
				"sync": `function (doc, oldDoc) {
					if (doc.sdk) {
						channel(doc.sdk);
					}
				}`
			}
		}
	}
	```

	This configuration file creates a database called `hello` and routes documents to different channels based on the `doc.sdk` property, if it exists.

2. Run the application where Couchbase Lite is installed. You should then see the documents that were replicated on the admin UI at http://localhost:4985/_admin/.

<img src="../img/admin-ui-getting-started.png" class=center-image />
