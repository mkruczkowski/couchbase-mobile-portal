---
id: release-notes
title: Release notes
permalink: references/couchbase-lite/release-notes/index.html
---

### Developer build 3

<block class="objc swift" />

- New Cross platform Query API for Objective-C framework

<block class="net" />

This developer build brings the concept of subdocuments (embedded JSON objects in a document), with some taming of the dispatch queue model. (A database gets a queue and all the objects associated with it share the same one. Callback queue has been removed, and callbacks now come over the action queue so that it is safe to access the DB directly from the callback). Thread safety checking has been made optional (default OFF) and can be enabled in the DatabaseOptions class.

<block class="all" />

### Developer build 2

<block class="objc swift" />

- Sub-document
- New CouchbaseLiteSwift framework for the Swift API

<block class="net" />

Despite the number being 2, this is the first developer build for Couchbase Lite .NET version 2.0.0. The reason it is number 2 is to keep parity with the other platforms. For more detailed notes about this release, see this document and for an API reference, see the attached compiled HTML files.

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

<block class="net" />

N/A