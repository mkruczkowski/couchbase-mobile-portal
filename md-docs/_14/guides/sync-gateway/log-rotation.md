---
id: log-rotation
title: Log Rotation
---

By default, Sync Gateway outputs the logs to standard out with the "HTTP" log key and can also output logs to a file. Prior to 1.4, the two main configuration options were `log` and `logFilePath` at the root of the configuration file.

```javascript
{
	"log": ["*"],
	"logFilePath": "/var/log/sync_gateway/sglogfile.log"
}
```

In Couchbase Mobile 1.4, Sync Gateway can now be configured to perform log rotation in order to minimize disk space usage.

## Log rotation configuration

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

|Property|Type|Description|
|:-------|:---|:----------|
|logFilePath|`string`|The path to the file to which the logs should be saved. There is no default.|
|logKeys|`string`|The list of logging keys. Defaults to "HTTP". The `*` symbol represents all tags.|
|logLevel|`string`|The level of logging. Possible values are "debug", "info", "warn", "error", "panic", "fatal".|
|rotation|`object`|The log file may be rotated by defining a "rotation" sub document. See details in the table below.|

The following table lists the available properties under the `rotation` object.

|Property|Type|Description|
|:-------|:---|:----------|
|maxsize|`integer`|The maximum size in MB of the log file before it gets rotated. Defaults to 100 MB.|
|maxage|`integer`|The maximum number of days to retain old log files.|
|maxbackups|`integer`|The maximum number of old log files to retain. Defaults to all log files.|
|localtime|`boolean`|If `true`, it uses the computer's local time to format the backup timestamp. Defaults to UTC.|

## Example Output

If Sync Gateway is running with the configuration shown above, after a total of 3.5 MB of log data, the contents of the `/var/log/sync_gateway` directory would have 3 files because `maxsize` is set to 1 MB.

```bash
/var/log/sync_gateway
├── sglogfile.log
├── sglogfile-2017-01-25T23-35-23.671.log
└── sglogfile-2017-01-25T22-25-39.662.log
```

## Windows Configuration

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


## Deprecation notice

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
