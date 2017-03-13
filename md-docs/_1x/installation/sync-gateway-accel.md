---
id: sg
title: Sync Gateway Accelerator
permalink: installation/sync-gateway-accel/index.html
---

Install Sync Gateway Accelerator on premise or on a cloud provider. You can download Sync Gateway Accelerator from the [Couchbase download page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile) or download it directly to a Linux system by using the `wget` or `curl` command.

```bash
wget https://packages.couchbase.com/releases/couchbase-sync-gateway/1.4.0/couchbase-sg-accel-community_1.4.0-2_x86_64.deb
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

## Requirements

|Ubuntu|CentOS/RedHat|Debian|Windows|macOS|
|:-----|:------------|:-----|:------|:----|
|12, 14|5, 6, 7|8|Windows 8, Windows 10, Windows Server 2012|Yosemite, El Capitan|

### Network configuration

Sync Gateway Accelerator uses specific ports for communication with the outside world. The following table lists the ports used for different types of Sync Gateway Accelerator network communication:

|Port|Description|
|:---|:----------|
|4985|Admin port. Internal HTTP port to run administrative tasks.|

Once you have downloaded Sync Gateway Accelerator on the distribution of your choice you are ready to install and start it as a service.

## Ubuntu

Install sg_accel with the dpkg package manager e.g:

```bash
dpkg -i couchbase-sg-accel-community_1.4.0-2_x86_64.deb
```

When the installation is complete sg_accel will be running as a service.

```bash
service sg_accel start
service sg_accel stop
```

The config file and logs are located in `/home/sg_accel`.

> **Note:** You can also run the **sg_accel** binary directly from the command line. The binary is installed at `/opt/couchbase-sg-accel/bin/sg_accel`.

## Red Hat/CentOS

Install sync_gateway with the rpm package manager e.g:

```bash
rpm -i couchbase-sg-accel-community_1.4.0-2_x86_64.rpm
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

## Debian

Install sg_accel with the dpkg package manager e.g:

```bash
dpkg -i couchbase-sg-accel-community_1.4.0-2_x86_64.deb
```

When the installation is complete sync_gateway will be running as a service.

```bash
systemctl start sg_accel
systemctl stop sg_accel
```

The config file and logs are located in `/home/sg_accel`.

## Windows

Install sync_gateway on Windows by running the .exe file from the desktop.

```bash
couchbase-sg-accel-community_1.4.0-2_x86_64.exe
```

When the installation is complete sg_accel will be installed as a service but not running.

Use the **Control Panel --> Admin Tools --> Services** to stop/start the service.

The config file and logs are located in ``.

## macOS

Download the **tar.gz** file using `wget` or `curl`.

```bash
wget https://packages.couchbase.com/releases/couchbase-sync-gateway/1.4.0/couchbase-sg-accel-community_1.4.0-2_x86_64.tar.gz
```

Install sg_accel by unpacking the tar.gz installer.

```bash
sudo tar -zxvf couchbase-sg-accel-community_1.4.0-2_x86_64.tar.gz --directory /opt
```

Create the sg_accel service.

```bash
$ sudo mkdir /Users/sg_accel

$ cd /opt/couchbase-sg-accel/service

$ sudo ./sg_accel_service_install.sh
```

To restart sg_accel (it will automatically start again).

```bash
$ sudo launchctl stop sg_accel
```

To remove the service.

```bash
$ sudo launchctl unload /Library/LaunchDaemons/com.couchbase.mobile.sg_accel.plist
```

The config file and logs are located in `/Users/sg_accel`.

## Connecting to Couchbase Server

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

> **Note:** Do not add, modify or remove data in the bucket using Couchbase Server SDKs or the Admin Console, or you will confuse Sync Gateway Accelerator. To modify documents, we recommend you use the Sync Gateway's REST API.

### Couchbase Server network configuration

In a typical mobile deployment on premise or in the cloud (AWS, RedHat etc), the following ports must be opened on the host for Couchbase Server to operate correctly: 8091, 8092, 8093, 8094, 11207, 11210, 11211, 18091, 18092, 18093. You must verify that any firewall configuration allows communication on the specified ports. If this is not done, the Couchbase Server node can experience difficulty joining a cluster. You can refer to the [Couchbase Server Network Configuration](/documentation/server/current/install/install-ports.html) guide to see the full list of available ports and their associated services.

## AWS

1. Browse to the [Sync Gateway Accelerator AMI](https://aws.amazon.com/marketplace/pp/B013XDNYRG) in the AWS Marketplace.
2. Click Continue.
3. Make sure you choose a key that you have locally.
4. Paste the [user-data.sh](https://raw.githubusercontent.com/couchbase/build/master/scripts/jenkins/mobile/ami/user-data.sh) script contents into the text area in Advanced Details
5. If you want to run a custom Sync Gateway Accelerator configuration, you should customize the variables in the Customization section of the user-data.sh script you just pasted.  You can set the Sync Gateway Accelerator config to any public URL and will need to update the Couchbase Server bucket name to match what's in your config.
6. Edit your Security Group to expose port 4984 to Anywhere

### Verify via curl

From your workstation:

```bash
$ curl http://public_ip:4984/sync_gateway/
```
You should get a response like the following:

```bash
{"committed_update_seq":1,"compact_running":false,"db_name":"sg_accel","disk_format_version":0,"instance_start_time":1446579479331843,"purge_seq":0,"update_seq":1}
```

### Customize configuration

For more advanced Sync Gateway Accelerator configuration, you will want to create a JSON config file on the EC2 instance itself and pass that to Sync Gateway when you launch it, or host your config JSON on the Internet somewhere and pass Sync Gateway Accelerator the URL to the file.

### View Couchbase Server UI

In order to login to the Couchbase Server UI, go to `http://public_ip:8091` and use the following credentials:

**Username**: Administrator

**Password**: The AWS instance id that can be found on the EC2 Control Panel (eg: i-8a9f8335)
