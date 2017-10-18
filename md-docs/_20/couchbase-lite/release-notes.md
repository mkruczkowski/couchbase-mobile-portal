---
id: release-notes
title: Release notes
permalink: references/couchbase-lite/release-notes/index.html
---

<block class="all" />

### Developer build 17

<block class="net" />

- Simplify encryption API.  `IEncryptionKey` is now `EncryptionKey` (class instead of factory)
- Overhaul logging, API change from setting levels via `Log.Domains` to `Database.SetLogLevels` and flags.  Domains reduced.
- No text logging by default.  Text logging (to a default location depending on platform) can be enabled by calling `EnableTextLogging()` inside of the relevant support class (e.g. Couchbase.Lite.Support.UWP).  All logging will go to a binary file in the default directory for a given platform (as determined by `IDefaultDirectoryResolver`).

<block class="all" />

### Developer build 16

<block class="objc swift" />

- Support Database Encryption
- Implement a new index API
- Move FTS.rank expression to Function.rank()
- Make Replicator's User-Agent header that includes information about library version and platform.

<block class="java" />

* Thread-safe with Database operation. (Other operations will be a thread-safe with next DB release)

<block class="net" />

- Collation API now supported on Android
- Redid Index API (indexes are now identified by name).  See the new `Index` class documentation.
- Encryption is now supported.  Encryption keys can be added onto the `DatabaseConfiguration` class.  This will encrypt database files and attachments.
- Added in a `rank()` function for `IExpression` to order by FTS ranking result
- Made a consistent User-Agent string that gets info on which platform is running
- Changed the default Collation locale to be the one currently running on device

<block class="all" />

### Developer build 15

<block class="objc swift" />

- Support Collation Expression.
- Support FTS Ranking Value Expression.
- Support database copy to allow to install a canned database.
- Allow to set logging level.

<block class="java" />

* Thread-safe with Database operation. (Other operations will be a thread-safe with next DB release)

<block class="net" />

- Collation API now supported on Linux platforms (Android coming soon)
- Statically compile, so iOS 9 will work now
- Add a database copy API (note:  current behavior will replace an existing database, but this may change) to make copies of a database (useful for seeding and/or backup).

<block class="all" />

### Developer build 14

<block class="objc swift" />

* Support Select all properties.
* Support Quantified expression (Any, AnyAndEvery, and Every).
* Support Query's isNullOrMissing expression.
* Support more Query functions including array, mathematics, string, and type functions.
* Support type setters on Document, Dictionary, Array, and Query's parameters.
* Support Int64 getter on Document, Dictionary, Array.
* Added Connecting and Offline to the Replicator's ActivityLevel status.

<block class="net" />

- Select all properties via `SelectResult.All()`
- Lots of new functions (Check the `Function` class) for use in querying
- Collection functions (Any / Every / AnyAndEvery) for running predicates on array items during query
- Collation API (see `Collation` class) for locale and language based sorting of strings
- Typed setter functions (`SetString`, `SetInt`, etc) and added `GetFloat` for completion
- Expanded the replicator statuses

<block class="java" />

* Support Select all properties.
* Support Quantified expression (Any, AnyAndEvery, and Every).
* Support Query's isNullOrMissing expression.
* Support more Query functions including array, mathematics, string, and type functions.
* Support type setters on Document, Dictionary, Array, and Query's parameters.

<block class="all" />

### Developer build 13

<block class="objc swift" />

* Support query projection with alias names
* CBLQuery returns CBLQueryResultSet<CBLQueryResult> instead of NSEnumerator<CBLQueryRow>. Same for Swift, Query return ResultSet<Result> instead of QueryIterator<QueryRow>. CBLQueryRow is still used by CBLPredicateQuery.
* CBLQueryResult supports get values both by indexes and by keys. Same for Result in Swift.
* CBLDocument.documentID -> CBLDocument.id
* Bug fixes : [#1819](https://github.com/couchbase/couchbase-lite-ios/issues/1819), [#1824](https://github.com/couchbase/couchbase-lite-ios/issues/1824), [#1825](https://github.com/couchbase/couchbase-lite-ios/issues/1825), [#1835](https://github.com/couchbase/couchbase-lite-ios/issues/1835)

<block class="java" />

* More Query API -> Meta, Limit, Offset
* Changed CouchbaseLiteException extends from Exception instead of RuntimeException

<block class="net" />

* Queries can now make use of `Limit()` and `Offset()`
* *The internal synching mechanism has been altered in a breaking way*.  With this release you need to use Sync Gateway 1.5.0-477 or higher.
* `SelectResult` can now use `As` to create an alias for that particular column
* Columns can now be accessed by key instead of just by index (by default the key is the last element of the property name that was selected [e.g. contact.address.city -> city], or an arbitrary 1-based index string $1, $2, $3, etc for rows that are not based on a property such as min, sum, etc.  If an alias is provided, that will be used instead)
* Corrected a silly spelling mistake (`Support.NetDestkop`-> `Support.NetDesktop`)
* Removed `DocumentID`, `Document`, etc from `IQueryRow` and use `IResult` instead (see docs\examples\Program.cs for how to get the Document or ID, but `Document` might make a comeback before GA)

<block class="all" />

### Developer build 12

<block class="objc swift" />

* Unify change event API for Database, Replicator, and LiveQuery by using block
* More Replicator API -> Channel and DocumentID
* More Query API -> Aggregate Functions, OrderBy, GroupBy / Having, Join, Projection, Parameters, Meta

<block class="net" />

* More Query API -> GroupBy, Having, Select items, Join, Functions, Parameters, Meta

<block class="java" />

* More Replicator API -> Cookie support, Certificate pinning, immediate conflict resolving for pull replication, Channel/DocID filter
* More Query API -> GroupBy, Having, Select items, Join, Functions, Parameters

<block class="all" />

### Developer build 11

<block class="java objc swift net" />

* LiveQuery
* Authentication for Replicator 

<block class="all" />

### Developer build 10

<block class="objc" />

* Fixed replicator not correctly encoding documents when it saves the documents
* Added an ability to pin server certificate to a replicator
* Fixed custom functions not being registered in all opened SQLite connections
* Fixed unused blobs not being garbaged after compacting a database

<block class="swift" />

* Added an ability to pin server certificate to a replicator
* Fixed custom functions not being registered in all opened SQLite connections
* Fixed unused blobs not being garbaged after compacting a database
* Fixed replicator not correctly encoding documents when it saves the documents

<block class="net" />

* ReplicationOptions -> ReplicatorConfiguration
* IReplication -> Replicator
* TLS support for replication (blips)
* HTTP Basic auth support for replication (via `ReplicationOptionsDictionary` -> 'AuthOptionsDictionary`).  This API will probably change.
* Online / offline network change handling
* Channel replication support (waiting on SG fix)
* Make DI system public to allow third party support assemblies

<block class="java" />

* Replication API
* Replicator - Basic Authentication
* Replicator - Online / Offline network change handling
* Fixed replicator not correctly encoding documents when it saves the documents

<block class="all" />

### Developer build 8

<block class="objc" />

* CBLDatabaseOptions -> CBLDatabaseConfiguration
* New DocumentChangeNotification implementation
* CBLArray optimization
* New Replicator API with Online / Offline support
* LiveQuery support
* Minor changes to CBLDatabase and CBLDocument API including
  - CBLDatabase.compact()
  - CBLDatabase.count()
  - CBLDatabase.contains(id)
  - CBLDictionary.remove(key)
  - CBLDictionary nil value support

<block class="swift" />

* DatabaseOptions -> DatabaseConfiguration
* New DocumentChangeNotification implementation
* ArrayObject optimization
* New Replicator API with Online / Offline support
* LiveQuery support
* Minor changes to Database and Document API including
  - Database.compact()
  - Database.count()
  - Database.contains(id)
  - DictionaryObject.remove(key)
  - DictionaryObject nil value support

<block class="net" />

- New APIs on Database such as `Count` and `Compact()`
- DatabaseOptions -> DatabaseConfiguration
- New native library delivery mechanism (transparent, but now requires `Activate` call on .NET and .NET Core via `Couchbase.Lite.Support.NetDesktop.Activate()`)

<block class="java" />

- New APIs on Database such as `count()`, `compact()` and contains(String id)
- New APIs on Dictionary such as `remove(String key)`
- DatabaseOptions -> DatabaseConfiguration
- Bug fixes

<block class="all" />

### Developer build 7

<block class="objc" />

- New unified API for CBLDocument, CBLReadOnlyDocument, CBLDictionary, CBLReadOnlyDictionary, CBLArray, CBLReadOnlyArray.
- Replaced CBLSubdocument with CBLDictionary.
- Removed DocumentChangeNotification from CBLDocument. The DocumentChangeNotification will be reimplemented at the Database level in the next release.
- New ConflictResolver API that take a single Conflict object as a parameter. The target, source, and commonAncestor property are ReadOnlyDocument object.
- Bug fixes and performance improvement from LiteCore.

<block class="swift" />

- New unified API for Document, ReadOnlyDocument, DictionaryObject, ReadOnlyDictionaryObject, ArrayObject, ReadOnlyArrayObject.
- Replaced Subdocument with DictionaryObject.
- Removed DocumentChangeNotification from Document. The DocumentChangeNotification will be reimplemented at the Database level in the next release.
- Bug fixes and performance improvement from LiteCore.

<block class="net" />

- A new unified and simpler API
- Finally, the public replication API for creating replications!

<block class="java" />

- A new unified and simpler API

<block class="all" />


### Developer build 6

<block class="java" />

- Database & Document Notification

### Developer build 5

<block class="objc" />

- Support replicating attachments
- Support automatic 1.x database upgrade to 2.0

<block class="swift" />

- Support replicating attachments
- Support automatic 1.x database upgrade to 2.0
- Fixed Swift replication delegate not functional (#1699)

<block class="net" />

- Replication! The new replicator is faster, but the protocol has changed, and the class API isn't yet finalized.  Also, unfortunately there is no public way to create replications yet but this will come soon.  
- Support automatic 1.x database upgrade to 2.0.  
- Various other optimizations under the hood.

<block class="java" />

- Blob
- Conflict Resolver

<block class="all" />

### Developer build 4

<block class="objc" />

- Replication! The new replicator is faster, but the protocol has changed, and the class API isn't yet finalized. Please read the documentation for details.

<block class="swift" />

- Cross platform Query API
- Replication! The new replicator is faster, but the protocol has changed, and the class API isn't yet finalized. Please read the documentation for details.

<block class="net" />

- Cross platform Query API

<block class="java" />

- CRUD operations
- Document with property type accessors
- Cross platform Query API

<block class="all" />

### Developer build 3

<block class="objc" />

- Cross platform Query API

<block class="swift" />

N/A

<block class="csharp" />

- Sub-document API
- Some taming of the dispatch queue model. (A database gets a queue and all the objects associated with it share the same one. Callback queue has been removed, and callbacks now come over the action queue so that it is safe to access the DB directly from the callback). Thread safety checking has been made optional (default OFF) and can be enabled in the DatabaseOptions class.

<block class="java" />

N/A

<block class="all" />

### Developer build 2

<block class="swift" />

- CouchbaseLiteSwift framework for the Swift API

<block class="objc" />

- Sub-document API

<block class="csharp" />

- CRUD operations
- Document with property type accessors
- Blob data type
- Database and Document Change Notification

<block class="java" />

N/A

<block class="all" />

### Developer build 1

<block class="objc" />

- CRUD operations
- Document with property type accessors
- Blob data type
- Database and Document Change Notification
- Query
	- NSPredicate based API
	- Grouping and Aggregation support

<block class="swift" />

N/A

<block class="csharp" />

N/A

<block class="java" />

N/A
