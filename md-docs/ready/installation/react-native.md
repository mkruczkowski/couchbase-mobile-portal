---
id: rn
title: React Native
permalink: installation/react-native/index.html
---

## Prerequisites

TODO

## Installation

- Create a new React Native project.

	```bash
	react-native init <project-name>
	```

- Navigate to your project directory and install the plugin.

	```bash
	cd <project-name>
	npm install react-native-couchbase-lite --save
	```

- Link the native libraries.

	```bash
	react-native link react-native-couchbase-lite
	```

	#### iOS only

	Download the Couchbase Lite iOS SDK from [here](http://www.couchbase.com/nosql-databases/downloads#) and drag **CouchbaseLite.framework**, **CouchbaseLiteListener.framework**, **CBLRegisterJSViewCompiler.h**, **libCBLJSViewCompiler.a** in the Xcode project.

	![](http://cl.ly/image/3Z1b0n0W0i3w/sdk.png)

- Start React Native.

	```bash
	react-native start
	```

- Build and run for iOS/Android.

## Example

Paste the following in a new file called **sync-gateway-config.json**.

```js
{
  "log": ["*"],
  "databases": {
    "todo": {
      "server": "walrus:",
      "users": { "GUEST": { "disabled": false, "admin_channels": ["*"] } }
    }
  }
}
```

Download Sync Gateway and start it with the configuration file saved above.

```js
~/Downloads/couchbase-sync-gateway/bin/sync_gateway sync-gateway-config.json
```

Open **index.ios.js** and add the following in the `componentWillMount` method.

```js
Couchbase.initRESTClient(manager => {
	const DB_NAME = 'todo';
	const SG_URL = 'http://localhost:4984/todo';
	var document = {'title': 'Couchbase Mobile', 'sdk': 'React Native'};
	manager.database.put_db({db: DB_NAME})
		.catch(e => console.warn(e))
		.then(res => manager.document.post({db: DB_NAME, body: document}))
		.then(res => console.log(res.obj));

	manager.server.post_replicate({body: {source: SG_URL, target: DB_NAME, continuous: true}})
		.then(res => manager.server.post_replicate({body: {source: DB_NAME, target: SG_URL, continuous: true}}))
		.catch(e => console.warn(e));
});
```

Reload the JavaScript in your React Native application, then open the Admin UI on [http://localhost:4985/_admin/db/todo](http://localhost:4985/_admin/db/todo) to display the document(s) that were pushed to Sync Gateway.

![](img/admin-ui.png)