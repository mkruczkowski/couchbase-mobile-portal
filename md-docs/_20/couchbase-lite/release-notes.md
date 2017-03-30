---
id: release-notes
title: Release notes
permalink: references/couchbase-lite/release-notes/index.html
---

### Developer build 3

<block class="objc" />

- Cross platform Query API

<block class="swift" />

N/A

<block class="csharp" />

- Sub-document API
- Some taming of the dispatch queue model. (A database gets a queue and all the objects associated with it share the same one. Callback queue has been removed, and callbacks now come over the action queue so that it is safe to access the DB directly from the callback). Thread safety checking has been made optional (default OFF) and can be enabled in the DatabaseOptions class.

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

<block class="all" />

### Developer build 1

<block class="objc swift" />

- CRUD operations
- Document with property type accessors
- Blob data type
- Database and Document Change Notification
- Query
	- NSPredicate based API
	- Grouping and Aggregation support

<block class="csharp" />

N/A