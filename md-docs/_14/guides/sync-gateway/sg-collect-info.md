---
id: sgcollect-info
title: SG Collect Info
permalink: guides/sync-gateway/sgcollect-info/index.html
---

With this release comes a new command line utility called `sgcollect_info` that provides us with detailed statistics for a specific node. Run `sgcollect_info` on each node individually, not on all simultaneously.

Outputs:

1. Logs
1. Configuration 
1. Expvars (exported variables) that contain important stats
1. System Level OS stats
1. Golang profile output (runtime memory and cpu profiling info)

## Installing Optional Dependencies

`sgcollect_info` will be able to collect more information if the following tools are installed:

* [Golang](https://golang.org/doc/install) -- this should be the same version that Sync Gateway was built with.

| SG Version | Go build version |
|:------------|:----|
| 1.3.0 | 1.5.3 |
| 1.3.1 | 1.6.3 |
| 1.4.0 | 1.7.1 |

If go is not installed, sgcollect_info will print the following error message, you can ignore this message and there is no need to report it.

`Exception during compression: [Error 2] The system cannot find the file specified
IMPORTANT:
  Compression using gozip failed.
  Falling back to python implementation.
  Please let us know about this and provide console output.`

* [Graphviz](http://www.graphviz.org/Download..php) -- this is used to render PDFs of the [go pprof](https://golang.org/pkg/net/http/pprof/) output.

## Zipfile contents

The tool creates the following log files in the ouput file.

| Log file | Description |
|:------------|:----|
| `sync_gateway_access.log` | The http access log for sync gateway (i.e which GETs and PUTs it has received and from which IPs) |
|`sg_accel_access.log`|The http access log for sg_accel (i.e which GETs and PUTs it has received and from which IPs)|
|`sg_accel_error.log`|The error log (all logging sent to stderr by sg\_accel) for the sg_accel process|
|`sync_gateway_error.log`|The error log (all logging sent to stderr by sync_gateway) for the sync\_gateway process|
|`<USER_DEFINED_LOGGER>.log`|The current log file as defined in the 1.4 ```logging``` config section (all logging sent to stderr by sync_gateway) for the sync\_gateway process|
|`<USER_DEFINED_LOGGER>-<DATE_STAMP>.log`|A timestamped historical log when log rotation has been configured in the 1.4 ```logging``` config section |
|`server_status.log`|The output of http://localhost:4895 for the running sync gateway|
|`db_db_name_status.log`|The output of http://localhost:4895/db_name for the running sync gateway|
|`sync_gateway.json`|The on-disk configuration file used by sync\_gateway when it was launched|
|`sg_accel.json`|The on-disk configuration file used by sg\_accel when it was launched|
|`running_server_config.log`|The configuration used by sync gateway as it is running (may not match the on-disk config as it can be changed on-the-fly)|
|`running_db_db_name_config.log`|The config used by sync gateway for the database specified by db\_name|
|`expvars_json.log`|The expvars (global exposed variables - see [http://www.mikeperham.com/2014/12/17/expvar-metrics-for-golang/](http://www.mikeperham.com/2014/12/17/expvar-metrics-for-golang/) for the running sync gateway instance)|
|`sgcollect_info_options.log`|The command line arguments passed to sgcollect\_info for this particular output|
|`sync_gateway.log`|OS-level System Stats|
|`expvars_json.log`|Exported Variables (expvars) from Sync Gateway which show runtime stats|
|`goroutine.pdf/raw/txt`|Goroutine pprof profile output|
|`heap.pdf/raw/txt`|Heap pprof profile output|
|`profile.pdf/raw/txt`|CPU profile pprof profile output|
|`syslog.tar.gz`|System level logs like /var/log/dmesg on Linux|
|`sync_gateway`|The Sync Gateway binary executable|
|`pprof_http_*.log`|The pprof output that collects directly via an http client rather than using go tool, in case Go is not installed|


## CLI command and parameters

To see the CLI command line parameters, run:

```bash
./sgcollect_info --help
```

## Examples


Collect Sync Gateway diagnostics and save locally:

```bash
./sgcollect_info /tmp/sgcollect_info.zip
```

Collect Sync Gateway diagnostics and upload them to the Couchbase Support AWS S3 bucket:

```bash
./sgcollect_info \
  --sync-gateway-config=/path/to/config.json \
  --sync-gateway-executable=/usr/bin/sync_gateway \
  --upload-host=s3.amazonaws.com/cb-customers \
  --customer=Acme \
  --ticket=123
  /tmp/sgcollect_info.zip
```
