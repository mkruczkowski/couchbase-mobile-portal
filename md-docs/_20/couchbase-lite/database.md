---
permalink: guides/couchbase-lite/native-api/database/index.html
---

<block class="java" />

⚠ Support in the current Developer Build is for Android only. The SDK cannot be used in Java applications.

<block class="all" />

## Databases

### Creating Databases

As the top-level entity in the API, new databases can be created using the {% st Database|CBLDatabase|Database|Database %} class by passing in a name, configuration, or both. The following example creates a database using the {% st Database(name: String)|initWithName:error:|new Database(string name)|new Database(String name, DatabaseConfiguration config) %} method.

<block class="swift" />

```swift
do {
  let database = try Database(name: "my-database")
} catch let error as NSError {
  NSLog("Cannot open the database: %@", error);
}
```

<block class="objc" />

```objectivec
NSError *error;
CBLDatabase* database = [[CBLDatabase alloc] initWithName:@"my-database" error:&error];
if (!database) {
	NSLog(@"Cannot open the database: %@", error);
}
```

<block class="csharp" />

```csharp
var database = new Database("my-database");
```

<block class="java" />

```java
DatabaseConfiguration config = new DatabaseConfiguration(/* Android Context*/ context);
Database database = new Database("my-database", config);
```

<block class="all" />

Just as before, the database will be created in a default location. Alternatively, the {% st Database(name: Strings, config: DatabaseConfiguration?)|initWithName:options:error:|new Database(string name, DatabaseConfiguration config)|new Database(String name, DatabaseOptions options) %} method can be used to provide specific options (the directory to create the database in, whether it is read-only etc.)

#### Opening 1.x databases

Databases that were created with Couchbase Mobile 1.2 or later can be read using the 2.0 API. Upon detecting it is a 1.x database file format, Couchbase Lite will automatically upgrade it to the new format used in 2.0. This feature is currently only available for the default storage type, SQLite (i.e not for ForestDB databases).

## Threading

You can instantiate multiple databases with the same name and directory; these will all share the same storage. This is the recommended approach if you will be calling Couchbase Lite from multiple threads or dispatch queues, since Couchbase Lite objects are not thread-safe and can only be called from one thread/queue. Otherwise, for use on a single thread/queue, it's more efficient to use a single instance.

<!--
	TODO: "The APIs will be thread safe in an upcoming DB- worth noting that somewhere maybe. So some of this stuff (while still accurate) may have to be revisited."
-->

<block class="swift" />

The following example opens the database on a background thread and inserts a document.

```swift
DispatchQueue.global(qos: .background).async {
	let database: Database
	do {
		database = try Database(name: "my-database")
	} catch let error {
		print(error.localizedDescription)
		return
	}
	
	let document = Document()
	document.set("created on background thread", forKey: "status")
	try? database.save(document)
}
```

{% include refs.html name='database' %}