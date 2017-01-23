---
id: log-rotation
title: Log Rotation
permalink: guides/sync-gateway/log-rotation/index.html
---

By default, Sync Gateway outputs the logs to standard out with the "HTTP" log key. Sync Gateway can also output logs to a file. Prior to 1.4, the two main configuration options were `log` and `logFilePath` at the root of the configuration file.

In Couchbase Mobile 1.4, Sync Gateway can now be configured to perform log rotation in order to minimize disk space usage.

## Log rotation configuration

The log rotation configuration is specified under the `logging` key. The following example demonstrates where the log rotation properties reside in the configuration file.

```javascript
{
  "logging": {
    "default": {
      "logFilePath": "/var/tmp/sglogfile.log",
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

As shown above, the "logging" property must contain a single named logging appender called "default". Note that if the "logging" property is specified, it will override the `log` and `logFilePath` at the root of the configuration file.

|Property|Type|Description|
|:-------|:---|:----------|
|logFilePath|`string`|The path to the file to which the logs should be saved. There is no default.|
|logKeys|`string`|The list of logging keys. Defaults to "HTTP". The * symbols means all tags.|
|logLevel|`string`|The level of logging. Possible values are "debug", "info", "warn", "error", "panic", "fatal"|
|rotation|`object`|The log file may be rotated by defining a "rotation" sub document. See details in the table below.|

The list of available properties under the `rotation` object are.

|Property|Type|Description|
|:-------|:---|:----------|
|maxsize|`integer`|The maximum size in MB of the log file before it gets rotated. Defaults to 100 MB.|
|maxage|`integer`|The maximum number of days to retain old log files.|
|maxbackups|`integer`|The maximum number of old log files to retain. Defaults to all log files.|
|localtime|`boolean`|If `true`, it uses the computer's local time to format the backup timestamp. Defaults to UTC.|

On non-windows platforms if the Sync Gateway receives a SIGHUP signal:

- If there is no "logging" subdocument and the top level "logFilePath" property is not defined no action is taken.
- If there is no "logging" subdocument and the top level "logFilePath" property is defined the log file handle will be cycled as it is currently.
- If the "logging" subdocument is defined, and the "default" appender has no "logFilePath" property defined no action is taken.
- If the "logging" subdocument is defined, and the "default" appender has no "rotation" subdocument defined the log file handle will be cycled as it is currently.
- If the "logging" subdocument is defined, and the "default" appender has a "rotation" subdocument defined call Logger.Rotate() to force a log file rotation.

After rotating, this initiates a cleanup of old log files according to the rotation properties defined for that appender.

## Deprecation notice

The current proposal is to remove the top level `log` and `logFilePath` properties in Sync Gateway 2.0. For users that want to migrate to the new logging config to write to a log file but do not need log rotation they should use a default logger similar to the following:

```javascript
"logging": {
  "default": {
    "logFilePath": "/var/tmp/sglogfile.log",
    "logKeys": ["*"],
    "logLevel": "debug"
  }
},
```
