---
id: config-properties
title: Config properties
permalink: guides/sync-gateway/config-properties/index.html
noedit: true
versions:
  - 1.3
  - 1.4
  - 1.5-beta
  - 1.5-beta2
---

<link rel="stylesheet" type="text/css" href="https://couchbase-docs.s3.amazonaws.com/assets/json-config-ui/json-config-ui.css">

A configuration file determines the runtime behavior of Sync Gateway, including server configuration and the database or set of databases with which a Sync Gateway instance can interact.

Using a configuration file is the recommended approach for configuring Sync Gateway, because you can provide values for all configuration properties and you can define configurations for multiple Couchbase Server databases.

When specifying a configuration file, the format to run Sync Gateway is:

```
$ sync_gateway sync-gateway-config.json
```

Configuration files have one syntactic feature that is not standard JSON: any text between back ticks (`) is treated as a string, even if it spans multiple lines or contains double-quotes. This makes it easy to embed JavaScript code, such as the sync and filter functions.

## Configuration Reference

<div id="swagger-ui"></div>
<div id="json-config-ui"></div>
<script src="https://couchbase-docs.s3.amazonaws.com/assets/json-config-ui/json-config-ui-bundle.js"></script>
<script>
	var frontMatter = "{{ page.versions | json | join: ','}}";
	var versions = frontMatter.split(",");
	var specsInfo = versions.map(function(version) {
		return {
			version: version,
			url: 'https://couchbase-docs.s3.amazonaws.com/mobile/' + version + '/configs/sg.1504711149319.json'
		};
	});
	setTimeout(function() {
		const ui = JSONConfigUIBundle({
  		dom_id: '#json-config-ui',
  		specs: specsInfo,
  		current: {{ site.version }}
  	});
  	window.ui = ui
	}, 0);
</script>