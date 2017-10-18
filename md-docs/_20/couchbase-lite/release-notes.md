---
id: release-notes
title: Release notes
permalink: references/couchbase-lite/release-notes/index.html
---

### Developer build 7

<block class="objc" />
2.0 DB7 includes the following features:
- New unified API for CBLDocument, CBLReadOnlyDocument, CBLDictionary, CBLReadOnlyDictionary, CBLArray, CBLReadOnlyArray.
- Replaced CBLSubdocument with CBLDictionary.
- Removed DocumentChangeNotification from CBLDocument. The DocumentChangeNotification will be reimplemented at the Database level in the next release.
- New ConflictResolver API that take a single Conflict object as a parameter. The target, source, and commonAncestor property are ReadOnlyDocument object.
- Bug fixes and performance improvement from LiteCore.

<block class="swift" />

2.0 DB7 includes the following features:
- New unified API for Document, ReadOnlyDocument, DictionaryObject, ReadOnlyDictionaryObject, ArrayObject, ReadOnlyArrayObject.
- Replaced Subdocument with DictionaryObject.
- Removed DocumentChangeNotification from Document. The DocumentChangeNotification will be reimplemented at the Database level in the next release.
- Bug fixes and performance improvement from LiteCore.

<block class="net" />

- A new unified and simpler API
- Finally, the public replication API for creating replications!

<block class="java" />

<block class="all" />

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
