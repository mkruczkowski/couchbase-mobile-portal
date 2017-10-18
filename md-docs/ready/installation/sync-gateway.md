---
id: sg
title: Sync Gateway
permalink: installation/sync-gateway/index.html
---

Install Sync Gateway on premise or on a cloud provider. You can download Sync Gateway from the [Couchbase download page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile) or download it directly to a Linux system by using the `wget` or `curl` command.

```bash
wget http://latestbuilds.hq.couchbase.com/couchbase-sync-gateway/1.3.0/1.3.0-274/couchbase-sync-gateway-community_1.3.0-274_x86_64.deb
```

All downloads follow the naming convention:

```bash
couchbase-sync-gateway-community_<REL>-<BUILDNUM><ARCH>.deb
```

Where 

- `REL` is the release number.
- `BUILDNUM` is the specific build number of the release.
- `ARCH` is the target architecture of the installer.

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

## Ubuntu

Install sync_gateway with the dpkg package manager e.g:

```bash
dpkg -i couchbase-sync-gateway-community_1.3.0-274_x86_64.deb
```

When the installation is complete sync_gateway will be running as a service.

```bash
service sync_gateway start
service sync_gateway stop
```

The config file and logs are located in `/home/sync_gateway`.

> **Note:** You can also run the **sync_gateway** binary directly from the command line. The binary is installed at `/opt/couchbase-sync-gateway/bin/sync_gateway`.

## Red Hat/CentOS

Install sync_gateway with the rpm package manager e.g:

```bash
rpm -i couchbase-sync-gateway-community_1.3.0-274_x86_64.rpm
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

## Debian

Install sync_gateway with the dpkg package manager e.g:

```bash
dpkg -i couchbase-sync-gateway-community_1.3.0-274_x86_64.deb
```

When the installation is complete sync_gateway will be running as a service.

```bash
systemctl start sync_gateway
systemctl stop sync_gateway
```

The config file and logs are located in `/home/sync_gateway`.

## Windows

Install sync_gateway on Windows by running the .exe file from the desktop.

```bash
couchbase-sync-gateway-community_1.3.0-274_x86_64.exe
```

When the installation is complete sync_gateway will be installed as a service but not running.

Use the **Control Panel --> Admin Tools --> Services** to stop/start the service.

The config file and logs are located in ``.

## macOS

Install sync_gateway by unpacking the tar.gz installer.

```bash
sudo tar --zxvf couchbase-sync-gateway-community_1.3.0-274_x86_64.tar.gz --directory /opt
```

Create the sync_gateway service.

```bash
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

## Walrus mode

By default, Sync Gateway uses a built-in, in-memory server called "Walrus" that can withstand most prototyping use cases, extending support to at most one or two users. In a staging or production environment, you must connect each Sync Gateway instance to a Couchbase Server cluster.

## Connecting to Couchbase Server

To connect Sync Gateway to Couchbase Server:

- [Download](https://www.couchbase.com/nosql-databases/downloads) and install Couchbase Server.
- Open the Couchbase Server Admin Console on [http://localhost:8091](http://localhost:8091) and log on using your 
administrator credentials.
- In the toolbar, select the **Data Buckets** tab and click the **Create New Data Bucket** button.
		![](/ready/installation/img/cb-create-bucket.png)
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

## AWS

1. Browse to the [Sync Gateway AMI](https://aws.amazon.com/marketplace/pp/B013XDNYRG) in the AWS Marketplace.
2. Click Continue.
3. Make sure you choose a key that you have locally.
4. Paste the [user-data.sh](https://raw.githubusercontent.com/couchbase/build/master/scripts/jenkins/mobile/ami/user-data.sh) script contents into the text area in Advanced Details
5. If you want to run a custom Sync Gateway configuration, you should customize the variables in the Customization section of the user-data.sh script you just pasted.  You can set the Sync Gateway config to any public URL and will need to update the Couchbase Server bucket name to match what's in your config.
6. Edit your Security Group to expose port 4984 to Anywhere

### Verify via curl

From your workstation:

```bash
$ curl http://public_ip:4984/sync_gateway/
```
You should get a response like the following:

```bash
{"committed_update_seq":1,"compact_running":false,"db_name":"sync_gateway","disk_format_version":0,"instance_start_time":1446579479331843,"purge_seq":0,"update_seq":1}
```

### Customize configuration

For more advanced Sync Gateway configuration, you will want to create a JSON config file on the EC2 instance itself and pass that to Sync Gateway when you launch it, or host your config JSON on the internet somewhere and pass Sync Gateway the URL to the file.

### View Couchbase Server UI

In order to login to the Couchbase Server UI, go to `http://public_ip:8091` and use the following credentials:

**Username**: Administrator

**Password**: The AWS instance id that can be found on the EC2 Control Panel (eg: i-8a9f8335)
