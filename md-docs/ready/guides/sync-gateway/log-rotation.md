---
id: log-rotation
title: Log Rotation
permalink: guides/sync-gateway/log-rotation/index.html
---

The Sync Gateway config will be updated to support a new top level "logging" property that will have an Object containing the logging properties including log rotation.

Below is the new logging config format:

```javascript
{
  "log":["*"],
  "logFilePath":"<PATH_TO_LOG_FILE">,
  "logging" : {
    "default" : {
      "logFilePath":"<PATH_TO_LOG_FILE>",
      "logKeys":["*"],
      "logLevel":<"debug"|"info"|"warn"|"error"|"panic"|"fatal">,
      "rotation":{
        "maxsize":100, // The maximum size in MB of the log file before it gets rotated. default - 100Mb
        "maxage":30, // The maximum number of days to retain old log files
        "maxbackups":5, // The maximum number of old log files to retain. default - all log files
        "localtime":true // If 'true' use computer's local time to format backup timestamp. default - UTC
      }
    }
  }
}
```

The "logging" sub document must contain a single named logging appender called "default".

The "default" appender can write to "stdout", write to a single log file or the log file may be rotated by defining a
 "rotation" sub document.
 
## Behaviour

In the absence of a "logging" sub document:

- If neither the "log" or "logFilePath" keys are specified, log entries with the "HTTP" log key will be written to 
standard out.
- If only the top level "log" property is defined, log entries with the log keys defined in the "log" property will 
be written to standard out.
- If both "log" and "logFilePath" are defined, log entries with the log keys defined in the "log" property will be 
written to standard out.
- If a "logging" subdocument is defined the "log" and "logFilePath" properties will be ignored.

The "logging" subdocument must contain a single valid appender config with the name "default", config validation 
should fail if this is not the case.

The "default" appender may be defined without a "logFilePath" property, in this case the appender will write to the 
processes "stdout".

If the "default" appender has a "logFilePath" property, the appender will write to the log file at the path specified.

Log entries that match the appender "logKeys" and "logLevel" properties will be written by the appender.

If an appender contains a "rotation" sub document and no "logFilePath" appender property is defined the log file will
 be rotated using the provided configuration.

On non-windows platforms if the Sync Gateway receives a SIGHUP signal:

- If there is no "logging" subdocument and the top level "logFilePath" property is not defined no action is taken.
- If there is no "logging" subdocument and the top level "logFilePath" property is defined the log file handle will be cycled as it is currently.
- If the "logging" subdocument is defined, and the "default" appender has no "logFilePath" property defined no action is taken.
- If the "logging" subdocument is defined, and the "default" appender has no "rotation" subdocument defined the log file handle will be cycled as it is currently.
- If the "logging" subdocument is defined, and the "default" appender has a "rotation" subdocument defined call Logger.Rotate() to force a log file rotation.

After rotating, this initiates a cleanup of old log files according to the rotation properties defined for that appender.

## Deprecation of old logging config

The current proposal is to remove the top level "log" and "logFilePath" properties in Sync Gateway 2.0.

For users that want to migrate to the new logging config to write to a log file but do not need log rotation they 
should use a default logger similar to the following:

```javascript
"logging": {
  "default": {
    "logFilePath": "/var/tmp/sglogfile.log",
    "logKeys": ["*"],
    "logLevel": "debug"
  }
},
```

## Example Configs

A basic logging-with-rotation.json SG config has been added to the examples folder

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