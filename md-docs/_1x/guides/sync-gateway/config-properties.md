---
id: config-properties
title: Config properties
permalink: guides/sync-gateway/config-properties/index.html
noedit: true
---

A configuration file determines the runtime behavior of Sync Gateway, including server configuration and the database or set of databases with which a Sync Gateway instance can interact.

Using a configuration file is the recommended approach for configuring Sync Gateway, because you can provide values for all configuration properties and you can define configurations for multiple Couchbase Server databases.

When specifying a configuration file, the format to run Sync Gateway is:

```
$ sync_gateway sync-gateway-config.json
```

Configuration files have one syntactic feature that is not standard JSON: any text between back ticks (`) is treated as a string, even if it spans multiple lines or contains double-quotes. This makes it easy to embed JavaScript code, such as the sync and filter functions.

## Configuration Reference

<script>
	window.configurl = 'https://couchbase-docs.s3.amazonaws.com/mobile/{{ site.version }}/configs/sg.json';
</script>
<div id="root"></div>
