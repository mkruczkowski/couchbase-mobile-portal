---
id: deployment-considerations
title: Deployment considerations
permalink: guides/sync-gateway/deployment/index.html
---

The following guide describes a set of recommended best practices for a production deployment of Couchbase Mobile.

## Sizing and Scaling

Your physical hardware determines how many active, concurrent users you can comfortably support for a single Sync Gateway. A quad-core/4GB RAM backed Sync Gateway can support up to 5k users. Larger boxes, such as a eight-core/8GB RAM backed Sync Gateway, can support 10k users, and so forth.

Alternatively, instead of scaling vertically, you can also scale horizontally by running Sync Gateway nodes as a cluster. (In general, you will want to have at least two Sync Gateway nodes to ensure high-availability in case one should fail.) This means running an identically configured instance of Sync Gateway on each of several machines, and load-balancing them by directing each incoming HTTP request to a random node. Sync Gateway nodes are “shared-nothing,” so they don’t need to coordinate any state or even know about each other. Everything they know is contained in the central Couchbase Server bucket. All Sync Gateway nodes talk to the same Couchbase Server bucket. This can, of course, be hosted by a cluster of Couchbase Server nodes. Sync Gateway uses the standard Couchbase “smart-client” APIs and works with database clusters of any size.

With multiple Sync Gateways, we recommend placing this cluster behind a load-balancer server to coordinate connection requests in clients. A popular load-balancer we've been recommended by our own community is [Nginx](https://www.nginx.com/blog/websocket-nginx/).

### Performance Considerations

Keep in mind the following notes on performance:

- Sync Gateway nodes don’t keep any local state, so they don’t require any disk beyond what's needed for logging and the application itself.
- Sync Gateway nodes do not cache much in RAM (and this is [tunable](../config-properties/index.html#cache)). Every request is handled independently. The Sync Gateway is written with the Go programming language, which does use garbage collection, so the memory usage might be somewhat higher than for C code. However, memory usage shouldn’t be excessive, provided the number of simultaneous requests per node is kept limited.
- Go is good at multiprocessing. It uses lightweight threads and asynchronous I/O. Adding more CPU cores to a Sync Gateway node can speed it up.
- As is typical with databases, writes are going to put a greater load on the system than reads. In particular, replication and channels imply that there’s a lot of fan-out, where making a change triggers sending notifications to many other clients, who then perform reads to get the new data.

In addition to adding Sync Gateway nodes, we recommend developers to also optimize how many connections they need to open to the sync tier. Very large-scale deployments might run into challenges managing large numbers of simultaneous open TCP connections. The replication protocol uses a "hanging-GET" technique to enable the server to push change notifications. This means that an active client running a continuous pull replication always has an open TCP connection on the server. This is similar to other applications that use server-push, also known as “Comet” techniques, as well as protocols like XMPP and IMAP. These sockets remain idle most of the time (unless documents are being modified at a very high rate), so the actual data traffic is low—the issue is just managing that many sockets. This is commonly known as the “C10k Problem” and it’s been pretty well analyzed in the last few years. Because Go uses asynchronous I/O, it’s capable of listening on large numbers of sockets provided that you make sure the OS is tuned accordingly and you’ve got enough network interfaces to provide a sufficiently large namespace of TCP port numbers per node.

## Security

**Authentication**

In a Couchbase Mobile production deployment, administrators typically perform operations on the Admin REST API. If Sync Gateway is deployed on an internal network, you can bind the [adminInterface](../config-properties/index.html#server) of Sync Gateway to the internal network. In this case, the firewall should also be configured to allow external connections to the public [interface](../config-properties/index.html#server) port.

To access the Admin REST API from an entirely different network or from a remote desktop we recommend to use [SSH tunnelling](https://whatbox.ca/wiki/SSH_Tunneling).

**Authorization**

In addition to the Admin REST API, a user can be assigned to a role with additional privileges. The role and the user assigned to it can be created in the configuration file. Then, the Sync Function's [requireRole()](../sync-function-api-guide/index.html#requirerolerolename) method can be used to allow certain operations only if the user has that role. The [adding security](../../../training/develop/adding-security/index.html#write-permissions) tutorial shows an example of this pattern.

**Data Model Validation**

In a NoSQL database, it is the application's responsibility to ensure that the documents are created in accordance with the data model adopted throughout the system. As an additional check, the Sync Function's [throw()](../sync-function-api-guide/index.html#throw) method can be used to reject documents that do not follow the pre-defined data model. The [adding security](../../../training/develop/adding-security/index.html?language=ios#validation) tutorial shows an example of this pattern.

**HTTPS**

You can run Sync Gateway behind a reverse proxy, such as NGINX, which supports HTTPS connections and route internal traffic to Sync Gateway over HTTP. The advantage of this approach is that NGINX can proxy both HTTP and HTTPS connections to a single Sync Gateway instance.

Alternatively, Sync Gateway can be [configured](../configuring-ssl/index.html) to only allow secure HTTPS connections, if you want to support both HTTP and HTTPS connections you will need to run two separate instances of Sync Gateway.

**Database Encryption**
		
[Database encryption](../../couchbase-lite/native-api/database/index.html#database-encryption) is available on the local database. Couchbase Lite uses SQLCipher; an open source extension to SQLite that provides transparent encryption of database files. The encryption specification is 256-bit AES.

{% if site.version == '1.4' %}

**Auditing**

Beginning in Couchbase Mobile 1.4, [log rotation](index.html#log-rotation) can be enabled in the configuration file.

{% endif %}

## Managing Tombstones

By design, when a document is deleted in Couchbase Mobile, they are not actually deleted from the database, but simply marked as deleted (by setting the `_deleted` property). This is discussed in the [Document](../../couchbase-lite/native-api/document/index.html#deleting-documents) guide. The reason that documents are not immediately removed is to allow all devices to see that they have been deleted - particularly in the case of devices that may not be online continuously and therefore not syncing regularly.

To actually remove the documents permanently, you need to *purge* them. This can be done in both [Couchbase Lite](../../couchbase-lite/native-api/document/index.html#purging-documents) and via the [Sync Gateway REST API](../../../references/sync-gateway/admin-rest-api/index.html#!/document/post_db_purge).

Beginning in Couchbase Mobile 1.3, documents can have a Time To Live (TTL) value - when the TTL expires the document will be purged from the local database. Note that this does not affect the copy of the document on any other device. This concept is covered in more detail in the [Document](../../couchbase-lite/native-api/document/index.html#document-expiration-ttl) guide.

Depending on the use case, data model and many more variables, there can be a need to proactively manage these tombstones as they are created. For example, you might decide that if a document is deleted on a Couchbase Lite client, that you want to purge the document (on that device) as soon as the delete has been successfully replicated out to Sync Gateway. Then later on Sync Gateway, set an expiration so that they are automatically purged after a set period (perhaps a week, or a month, to allow for all other devices to sync and receive the delete notifications) - more on this later. If a document is deleted on the Sync Gateway itself (say by a batch process or REST API client), you may similarly want to set a TTL, and on the Couchbase Lite devices you can monitor the [Database Change Notifications](../../couchbase-lite/native-api/database/index.html#database-notifications) and purge locally whenever a document is marked as deleted. 

## Log Rotation

{% if site.version == '1.4' %}

### Built-in log rotation

By default, Sync Gateway outputs the logs to standard out with the "HTTP" log key and can also output logs to a file. Prior to 1.4, the two main configuration options were `log` and `logFilePath` at the root of the configuration file.

```javascript
{
	"log": ["*"],
	"logFilePath": "/var/log/sync_gateway/sglogfile.log"
}
```

In Couchbase Mobile 1.4, Sync Gateway can now be configured to perform log rotation in order to minimize disk space usage.

#### Log rotation configuration

The log rotation configuration is specified under the `logging` key. The following example demonstrates where the log rotation properties reside in the configuration file.

```javascript
{
  "logging": {
    "default": {
      "logFilePath": "/var/log/sync_gateway/sglogfile.log",
      "logKeys": ["*"],
      "logLevel": "debug",
      "rotation": {
        "maxsize": 1,
        "maxage": 30,
        "maxbackups": 2,
        "localtime": true
      }
    }
  },
  "databases": {
    "db": {
      "server": "walrus:data",
      "bucket": "default",
      "users": {"GUEST": {"disabled": false,"admin_channels": ["*"]}}
    }
  }
}
```

As shown above, the `logging` property must contain a single named logging appender called `default`. Note that if the "logging" property is specified, it will override the top level `log` and `logFilePath` properties.

The descriptions and default values for each logging property can be found on the [Sync Gateway configuration](../config-properties/index.html) 
page.

#### Example Output

If Sync Gateway is running with the configuration shown above, after a total of 3.5 MB of log data, the contents of the `/var/log/sync_gateway` directory would have 3 files because `maxsize` is set to 1 MB.

```bash
/var/log/sync_gateway
├── sglogfile.log
├── sglogfile-2017-01-25T23-35-23.671.log
└── sglogfile-2017-01-25T22-25-39.662.log
```

#### Windows Configuration

On MS Windows `logFilePath` supports the following path formats.

```javascript
"C:/var/tmp/sglogfile.log"
`C:\var\tmp\sglogfile.log`
`/var/tmp/sglogfile.log`
"/var/tmp/sglogfile.log"
```
Log rotation will not work if `logFilePath` is set to the path below as it is reserved for use by the Sync Gateway Windows service wrapper.

```bash
C:\Program Files (x86)\Couchbase\var\lib\couchbase\logs\sync_gateway_error.log
```

#### Deprecation notice

The current proposal is to remove the top level `log` and `logFilePath` properties in Sync Gateway 2.0. For users that want to migrate to the new logging config to write to a log file but do not need log rotation they should use a default logger similar to the following:

```javascript
{
	"logging": {
		"default": {
			"logFilePath": "/var/log/sync_gateway/sglogfile.log",
			"logKeys": ["*"],
			"logLevel": "debug"
		}
	}
}
```

{% endif %}

### OS log rotation

In production environments it is common to rotate log files to prevent them from taking too much disk space, and to support log file archival.

By default Sync gateway will write log statements to stderr, normally stderr is redirected to a log file by starting Sync Gateway with a command similar to the following:

```bash
sync_gateway sync_gateway.json 2>> sg_error.log
```

On Linux the logrotate tool can be used to monitor log files and rotate them at fixed time intervals or when they reach a certain size. Below is an example of a logrotate configuration that will rotate the Sync Gateway log file once a day or if it reaches 10M in size.

```
/home/sync_gateway/logs/* { 
    daily 
    rotate 1 
    size 10M  
    delaycompress 
    compress 
    notifempty 
    missingok
```

The log rotation is achieved by renaming the log file with an appended timestamp. The idea is that Sync Gateway should recreate the default log file and start writing to it again. The problem is Sync Gateway will follow the renamed file and keep writing to it until Sync gateway is restarted. By adding the copy truncate option to the logrotate configuration, the log file will be rotated by making a copy of the log file, and then truncating the original log file to zero bytes.

```
/home/sync_gateway/logs/* { 
    daily 
    rotate 1 
    size 10M
    copytruncate
    delaycompress 
    compress 
    notifempty 
    missingok 
}
```

Using this approach there is a possibility of loosing log entries between the copy and the truncate, on a busy Sync Gateway instance or when verbose logging is configured the number of lost entries could be large.

In Sync Gateway 1.1.0 a new configuration option has been added that gives Sync Gateway control over the log file rather than relying on **stderr**. To use this option call Sync Gateway as follows:

```bash
sync_gateway -logFilePath=sg_error.log sync_gateway.json
```

[//]: # "TODO: Link can break."
The **logFilePath** property can also be set in the configuration file at the [server level](../config-properties/index.html#server-configuration).

If the option is not used then Sync Gateway uses the existing stderr logging behaviour. When the option is passed Sync Gateway will attempt to open and write to a log file at the path provided. If a Sync Gateway process is sent the `SIGHUP` signal it will close the open log file and then reopen it, on Linux the `SIGHUP` signal can be manually sent using the following command:

```bash
pkill -HUP sync_gateway
```

This command can be added to the logrotate configuration using the 'postrotate' option:

```
/home/sync_gateway/logs/* { 
    daily 
    rotate 1 
    size 10M
    delaycompress 
    compress 
    notifempty 
    missingok
    postrotate
        /usr/bin/pkill -HUP sync_gateway > /dev/null
    endscript
}
```

After renaming the log file logrotate will send the `SIGHUP` signal to the `sync_gateway` process, Sync Gateway will close the existing log file and open a new file at the original path, no log entries will be lost.

## Troubleshooting

### Troubleshooting and Fine-Tuning

In general, [curl](https://curl.haxx.se/), a command-line HTTP client, is your friend. You might also want to try [httpie](https://github.com/jkbrzt/httpie), a human-friendly command-line HTTP client. By using these tools, you can inspect databases and documents via the Public REST API, and look at user and role access privileges via the Admin REST API.

An additional useful tool is the admin-port URL **/databasename/_dump/channels**, which returns an HTML table that lists all active channels and the documents assigned to them. Similarly,**/databasename/_dump/access** shows which documents are granting access to which users and channels.

We encourage Sync Gateway users to also reach back out to our engineering team and growing developer community for help and guidance. You can get in touch with us on our mailing list at our [Couchbase Mobile forum](https://forums.couchbase.com/c/mobile).

### How to file a bug

If you're pretty sure you've found a bug, please [file a bug report](https://github.com/couchbase/sync_gateway/issues?q=is%3Aopen) at our GitHub repository and we can follow-up accordingly.

## Enterprise Customer Support

### Couchbase Technical Support

Support email: support@couchbase.com

Support phone number: +1-650-417-7500, option #1

Support portal: [http://support.couchbase.com](http://support.couchbase.com)

To speed up the resolution of your issue, we will need some information to troubleshoot what is going on. The more information you can provide in the questions below the faster we will be able to identify your issue and propose a fix:

- Priority and impact of the issue (P1 and production impacting versus a P2 question)
- What versions of the software are you running - Membase/Couchbase Server, moxi, and client drivers?
- Operating system version, architecture (32-bit or 64-bit) and deployment (physical hardware, Amazon EC2, RightScale, etc.)
- Number of nodes in the cluster, how much physical RAM in each node, and per-node RAM allocated to Couchbase Server
- What steps led to the failure or error?
- Information around whether this is something that has worked successfully in the past and if so what has changed in the environment since the last successful operation?
- Provide us with a current snapshot of logs taken from each node of the system and uploaded to our support system via the instructions below

If your issue is urgent, please make a phone call as well as send an e-mail. The phone call will ensure that an on-call engineer is notified.

### Sync Gateway Logs

The Sync Gateway logs will give us further detail around the issue itself and the health of your environment.

Sync Gateway 1.3.x includes a command line utility `sgcollect_info` that provides us with detailed statistics for a specific node. Run `sgcollect_info` on each node individually, not on all simultaneously.

Example usage:

Linux (run as root or use sudo as below)


```bash
sudo /opt/couchbase/bin/sgcollect_info <node_name>.zip
```

Windows (run as an administrator)

```
C:\Program Files\Couchbase\Server\bin\sgcollect_info <node_name>.zip
```

Run `sgcollect_info` on all nodes in the cluster, and upload all of the resulting files to us.

### Sharing Files with Us

The `sgcollect_info` tool can result in large files. Simply run the command below, replacing `<FILE NAME>` and `<YOUR COMPANY NAME>`, to upload a file to our cloud storage on Amazon AWS. Make sure you include the last slash (`/`) character after the company name.

```bash
curl --upload-file FILE NAME https://s3.amazonaws.com/customers.couchbase.com/<YOUR COMPANY NAME>/
```

> **Note:** we ship `curl` with Couchbase Server, on Linux this is located in `/opt/couchbase/bin/`

Firewalled Sync Gateway Nodes

If your Sync Gateway nodes do not have internet access, the best way to provide the logs to us is to copy the files then run `curl` from a machine with internet access. We ship a Windows `curl` binary as part of Couchbase Server, so if you have Couchbase Server installed on a laptop or other system which has an Internet connection you can upload from there. Alternatively you can download standalone Curl for Windows:

[http://curl.haxx.se/download.html](http://curl.haxx.se/download.html)

Once uploaded, please send an e-mail to support@couchbase.com letting us know what files have been uploaded.
