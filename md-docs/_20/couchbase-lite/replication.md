---
permalink: guides/couchbase-lite/native-api/replication/index.html
---

<block class="java" />

⚠ Support in the current Developer Build is for Android only. The SDK cannot be used in Java applications.

<block class="all" />

## Replication

Couchbase Mobile 2.0 uses a [new replication protocol](https://github.com/couchbase/couchbase-lite-core/wiki/Replication-Protocol), based on WebSockets. This protocol has been designed to be fast, efficient, easier to implement, and symmetrical between client/server.

### Compatibility

The new protocol is incompatible with version 1.x, and with CouchDB-based databases including PouchDB and Cloudant. Since Couchbase Lite 2 developer builds support only the new protocol, to test replication you will need to run the corresponding developer build of Sync Gateway, which supports both.

### Example

To run an example, create a new file named **sync-gateway-config.json** with the following.

```javascript
{
  "databases": {
    "db": {
      "server":"walrus:",
      "users": {
        "GUEST": {"disabled": false, "admin_channels": ["*"]}
      },
      "unsupported": {
        "replicator_2":true
      }
    }
  }
}
```

There are a few things to note here:

- In this developer build, there is no authentication yet so you're enabling the GUEST account on the Sync Gateway you use for replication testing.
- Filtering isn't implemented yet.

Download the current Sync Gateway [developer build](../../whatsnew.html) and start it from the command line with the configuration file created above.

```bash
~/Downloads/couchbase-sync-gateway/bin/sync_gateway sync-gateway-config.json
```

For platform specific installation instructions, refer to the Sync Gateway [installation guide](../../../current/installation/sync-gateway/index.html).

### Replication API

Replication objects are now bidirectional. You no longer need to create two separate Replications to push and pull. An instance's `push` and `pull` properties govern which direction(s) to transfer documents; they both default to `true`, so if you want unidirectional replication you'll need to turn the other direction off. The following example creates a bi-directional replications with Sync Gateway.

<block class="objc" />

```objectivec
NSURL *url = [[NSURL alloc] initWithString:@"blip://localhost:4984/db"];

CBLReplicatorConfiguration* config = [[CBLReplicatorConfiguration alloc] init];
config.database = database;
config.target = [CBLReplicatorTarget url: url];
config.continuous = YES;

CBLReplication *replication = [[CBLReplicator alloc] initWithConfig: config];
[replication start];
```

<block class="swift" />

```swift
let url = URL(string: "blip://localhost:4984/db")!
var config = ReplicatorConfiguration()
config.database = db
config.target = .url(url)
config.continuous = true
        
let replication = Replicator(config: config);
replication.start()
```

<block class="csharp" />

```c#
var url = new Uri("ws://localhost:4984/db");
var config = new ReplicatorConfiguration {
    Database = db,
    Target = url
};
var replication = new Replicator(config);
replication.Start();
```

<block class="java" />

```java
URI uri = null;
try {
	uri = new URI("blip://10.0.2.2:4984/db");
} catch (URISyntaxException e) {
	e.printStackTrace();
}
ReplicatorConfiguration replConfig = new ReplicatorConfiguration(database, uri);
Replicator replicator = new Replicator(replConfig);
replicator.start();
```

<block class="all" />

As shown in the code snippet above, the URL scheme for remote database URLs has changed in Couchbase Lite 2.0. You should now use `blip:`, or `blips:` for SSL/TLS connections (or the more-standard `ws:` / `wss:` notation). You can access the Sync Gateway `_all_docs` endpoint [http://localhost:4984/db/\_all\_docs?include_docs=true](http://localhost:4984/db/_all_docs?include_docs=true) to check that the documents are successfully replicated.

Starting in Couchbase Lite 2.0, replication between two local databases is now supported. This isn't often needed, but it can be very useful. For example, you can implement incremental backup by pushing your main database to a mirror on a backup disk.

> **Troubleshooting:** As always with replication, logging is your friend. The `Sync` tag logs information specific to the replicator, and `WS` logs about the WebSocket. If you have connectivity problems, make sure that any proxy server (like nginx) in front of Sync Gateway supports WebSockets.

<block class="csharp java" />

#### Replication Change Listener

The replication change event can be used to monitor the status of the replication. The following example logs a message to the console once the replication has finished (i.e when the status is equal to `STOPPED`).

<block class="csharp" />

```csharp
replication.StatusChanged += (sender, e) => {
	if (e.Status.Activity == ReplicatorActivityLevel.Stopped) {
		Console.WriteLine("Replication has completed.");
	}
};
```

<block class="java" />

```java
replicator.addChangeListener(new ReplicatorChangeListener() {
		@Override
		public void changed(Replicator replicator, Replicator.Status status, CouchbaseLiteException error) {
				if (status.getActivityLevel().equals(Replicator.ActivityLevel.STOPPED)) {
						Log.d("app", "Replication was completed.");
				}
		}
});
```

<block class="java csharp" />

The following table lists the different activity levels in the API and the meaning of each one.

|State|Meaning|
|:----|:------|
|`STOPPED`|The replication is finished or hit a fatal error.|
|`OFFLINE`|The replicator is offline as the remote host is unreachable.|
|`CONNECTING`|The replicator is connecting to the remote host.|
|`IDLE`|The replication is inactive; either waiting for changes or offline as the remote host is unreachable|
|`BUSY`|The replication is actively transferring data.|

<block class="all" />

### Conflict Handling

We're approaching conflict handling differently, and more directly. Instead of requiring application code to go out of its way to find conflicts and look up the revisions involved, Couchbase Lite will detect the conflict (while saving a document, or during replication) and invoke an app-defined conflict-resolver handler. The conflict resolver is given "source" document properties, "target" document properties, and (if available) the properties of the common ancestor revision.

* When saving a {% st Document|CBLDocument|Document|Document %}, "target" properties will be the in-memory properties of the object, and "source" properties will be one ones already saved in the database (by some other application thread, or by the replicator.)
* During replication, "target" properties will be the ones in the local database, and "source" properties will be the ones coming from the server.

The resolver is responsible for returning the resulting properties that should be saved. There are of course a lot of ways to do this. By the time 2.0 is released we want to include some resolver implementations for common algorithms (like the popular "last writer wins" that just returns "my" properties.) The resolver can also give up by returning {% st nil|nil|null|null %}, in which case the save fails with a "conflict" error. This can be appropriate if the merge needs to be done interactively or by user intervention.

If the database doesn't have a conflict resolver (the default situation), a default algorithm is used that picks the revision with the larger number of changes in its history.