---
id: api-guide
title: API Guide
---

{% include landing.html %}

### What's New?

Most of Couchbase Lite has been rewritten, based on what we've learned from implementing a lightweight cross-platform NoSQL database.

* The core functionality is implemented in a C++ library known as Couchbase Lite Core, or LiteCore. This library is used on all platforms, eliminating a lot of code duplication. The result is more consistent behavior across platforms, and faster development of new features.
* Much higher performance, thanks to LiteCore. Efficient code, and better algorithms and data storage schema, mean that Couchbase Lite 2.0 runs many times faster than 1.x. Performance will vary by platform and by operation, but we've seen large database insertion and query tasks run 5x faster on iOS.
* Queries are now based on expressions, with semantics based on Couchbase Server's N1QL query language. This reduces the learning curve, compared to map/reduce, and makes it easier to create flexible queries. It's also a better fit with platform query APIs like LINQ and NSPredicate.
* Full-text search is now available on all platforms.
* The document API has changed significantly, reflecting feedback from developers. Document objects are mutable, so you can update properties incrementally and then save changes. We provide efficient typed accessors so you can get and set numeric/boolean values without the overhead of conversion to objects. In later preview releases we'll add a cross-platform object modeling API (comparable to CBLModel in iOS 1.x) that lets you map documents to native objects.
* Conflict handling is much more direct. You provide conflict-resolver callbacks to control what happens when a save conflicts with a new change, or when the replicator pulls a new revision. Conflicts won't pile up invisibly causing scalability problems. (We will be providing canned conflict resolvers for common algorithms.)

### What's Missing?

Some of the new features aren't implemented yet, and some existing features are temporarily missing because they have yet to be adapted to the new core engine and APIs. Pardon our dust! We will be releasing new previews often, so if this one is too incomplete for you to evaluate or use, please check back later.

In developer build #2:

* The replicator is unavailable. It needs to be adapted to the LiteCore APIs.
* The REST API (Listener) is unavailable.
* Map/reduce queries aren't supported. We are still evaluating whether to support them in 2.0; your feedback is welcome.
* The database file format has changed, and there is not yet any support for upgrading/migrating 1.x databases. (The format is likely to change again, incompatibly, in future preview releases until we implement migration.)
* Object modeling (mapping documents to native objects) isn't implemented yet.
* Components provided for .NET Core and UWP

### What projects are in the solution?

- Couchbase.Lite:  Targeting .NET Standard 1.4, this is where 99% of the functionality lives
- Couchbase.Lite.Support.UWP: Required for UWP to function correctly
- Couchbase.Lite.Support.iOS: Required for Apple targets to function correctly (name may change as it also includes tvOS functionality)
- Couchbase.Lite.Support.Android: Required for Android targets to function correctly

When a support assembly is required, your app must call the relevant `Activate()` function inside of the class that is included in the assembly (there is only one public class in each support assembly).  For example, UWP looks like `Couchbase.Lite.Support.UWP.Activate()`.  Currently the support assemblies provide dependency injected mechanisms for default directory logic, and platform specific logging (i.e. Android will log to logcat with correct log levels and tags.  No more "mono-stdout" at always info level).

### How can I get it quickly?

Add http://nuget.mobile.couchbase.com/nuget/Developer/ to your Nuget package sources and expect a new build approximately every 2 weeks!

## Getting Started

<div class="dp">
	<div class="tiles">
		<div class="column size-1of2">
			<div class="box">
				<div class="container">
					<a href="https://www.couchbase.com/nosql-databases/downloads#couchbase-mobile" taget="_blank">
						<p>Download Developer Build</p>
					</a>
				</div>
			</div>
		</div>
		<div class="column size-1of2">
			<div class="box">
				<div class="container">
					<a href="http://cb-mobile.s3.amazonaws.com/api-references/couchbase-lite-2.0DB1/index.html" taget="_blank">
						<p>API References</p>
					</a>
				</div>
			</div>
		</div>
	</div>
</div>

Couchbase Lite 2 for .NET is a bit more complicated to build than 1.x because it makes heavy use of compiled native libraries.

To build the entire project from source requires several tools working together:

- .NET Core Windows
    - CMake
    - Visual Studio 2015+ for native components
    - Visual Studio 2017+ or dotnet CLI for managed components

- Universal Windows
    - CMake
    - Visual Studio 2015+ for native components
    - Visual Studio 2015+ for managed components

- .NET Core macOS
    - CMake
    - XCode 
    - Xamarin Studio 6.2+, Visual Studio for Mac or dotnet CLI

- .NET Core Linux
    - CMake
    - clang compiler
    - dotnet CLI

- Xamarin Android
    - CMake
    - Android NDK
    - Xamarin Android 7+

- Xamarin Apple (iOS / tvOS)
    - CMake
    - XCode
    - Xamarin iOS 10+

**NOTE** For DB002 the only tested platform is .NET Core (on Windows, macOS, and Ubuntu 16.04).  UWP support classes are provided but currently unable to be tested.  Xamarin iOS and Android support classes are not yet provided.  They will still compile against these platforms, but certain things will fail (like using the default directory, and logging).  These platforms will be fully added in future developer builds.

## The New API

Here are the highlights of the new API. We assume you're already familiar with Couchbase Lite 1.x. This isn't an exhaustive description; please refer to the [Sandcastle-generated API docs](https://github.com/couchbase/couchbase-lite-net/releases/tag/2.0.0-db002) for details.

### No Manager

You'll notice that `Manager` is gone. Instead, databases are the top-level entities in the API. The main function of `Manager` was to act as a collection of databases, both conceptually and in the filesystem, but it turned out not to be worth the added complexity. Instead, in 2.0 you create and manage databases individually, the way you'd manage files.

### Most things are `interfaces`

Things like databases, blobs, encryption keys, etc are no longer concrete classes but interfaces.  Especially things that are generated by the library itself.  This allows for more flexibility in what the library returns, and the hierarchy of inheritance internally.

### Thread safety notes

Thread safety will be rigorously enforced, and fail quickly with an exception to indicate incorrect usage.  The way the thread safety models will be enforced is via dispatch queues (which, as their name suggests, are inspired by Apple's [Grand Central Dispatch](https://developer.apple.com/library/content/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html) library).  This means that for most properties and methods, access will be limited to inside the queue and calling them from anywhere else will result in an exception.  There are synchronous and asynchronous ways to add work to a given queue so a block of work does not necessarily need to block the thread it is added from (`async` / `await` can be used as well).  You can get a hold of the proper queue via the `ActionQueue` on any `IThreadSafe` object, and use the appropriate Dispatch methods to schedule blocks of work onto it.  Note that each object needs to have its own queue used (this may change to simplify things so that a database controls a queue and each object it creates shares that one)

## Databases

### Creating Databases

As the top-level entity in the API, you now create database objects directly and use them via the `IDatabase` interface. You instantiate one by using the `DatabaseFactory` static class and passing in a name, options, or both. Just as before, the database will be created in a default location. You can override this by specifying a parent directory in the CBLDatabaseOptions.

You can instantiate multiple `IDatabases` with the same name and directory because there is no longer a manager to control this but the details of such an act have yet to be worked out.  It is better and more efficient to use a single instance and queue work from various threads onto its dispatch queue.

### Transactions / batch operations

As before, if you're making multiple changes to a database at once, it's *much* faster to group them together. (Otherwise each individual change incurs overhead, from flushing writes to the filesystem to ensure durability.) In 2.0 we've renamed the method, to `InBatch()`, to emphasize that Couchbase Lite does not offer transactional guarantees, and that the purpose of the method is to optimize batch operations rather than to enable ACID transactions.

At the *local* level this operation is still transactional: no other `IDatabase` instances, including ones managed by the replicator or HTTP listener, can make changes during the execution of the block, and other instances will not see partial changes. But Couchbase Mobile is a *distributed* system, and due to the way replication works, there's no guarantee that Sync Gateway or other devices will receive your changes all at once.

Again, the behavior of the method hasn't changed, just its name.

## Documents

Documents have changed a lot (and once again, it's an interface called `IDocument`). The data model is still the same — a JSON object with a fixed ID string — but the API has absorbed ideas from iOS' `CBLModel` to make it easier to work with.

> Note: `CBLModel` is coming to .NET in a future release which means you will be able to save directly from your class types to the database without going through a dictionary or anything.  It's working now more or less but there are still some final details to iron out.

### Mutability

The biggest change is that `IDocument`'s properties are now mutable. Instead of having to make a copy of the properties dictionary, update it, and then save it back to the document, you can now modify individual properties in place and then save.

This does create the possibility of confusion, since the document's in-memory state may not match what's in the database. Unsaved changes are not visible to other `IDatabase` instances (i.e. other threads that may have other instances), or to queries.

### Typed Accessors

`IDocument` now offers a set of property accessors for various scalar types, including boolean, integers, floating-point and strings. These accessors take care of converting to/from JSON encoding, and make sure you get the type you're expecting: for example, `GetString()` returns either a `string` or `null`, so you can't get an unexpected object class and crash trying to use it as a string. (Even if the property in the document has an incompatible type, the accessor returns `null`.)

> Note: If you're looking for these accessors in the source files, they're not in `IDocument.cs`; they're defined in its parent interface `IPropertyContainer`, so look in `IPropertyContainer.cs`.

### Subdocuments

>Note: Subdocuments aren't available yet in this developer preview. Instead, nested JSON objects are exposed as `IDictionary<string, object>`, as they were in 1.x. But expect this to change soon, hopefully in DP3.

A *subdocument* is a nested document with its own set of named properties. In JSON terms it's a nested object. This isn't a new feature of the document model; it's just that we're exposing it in a more structured form. In Couchbase Lite 1.x you would see a nested object as a nested `IDictionary<string, object>` (and honestly a lot of the time it was a `JObject` causing massive confusion). In 2.0 we expose it as an `ISubdocument` object instead.

`ISubdocument`, like `IDocument`, inherits from `IPropertyContainer`. That means it has the same set of type-specific accessors discussed in the previous section. Like `IDocument`, it's mutable, so you can make changes in-place. The difference is that a subdocument doesn't have its own ID. It's not a first-class entity in the database, it's just a nested object within the document's JSON. It can't be saved individually; changes are persisted when you save its document.

### Attachments, AKA Blobs

We've renamed "attachments" to "blobs", for clarity. The new behavior should be clearer too: an `IBlob` is now a normal object that can appear in a document as a property value, either at the top level or in a subdocument. In other words, there's no special API for creating or accessing attachments; you just instantiate an `IBlob` via the `BlobFactory` class and set it as the value of a property, and then later you can get the property value, which will be a `IBlob` object.

`IBlob` itself has a simple API that lets you access the contents as in-memory data (an `byte[]` object) or as a `Stream`.  It also supports an optional `type` property that by convention stores the MIME type of the contents. Unlike `Attachment`, blobs don't have names; if you need to associate a name you can put it in another document property, or make the filename be the property name (e.g. `doc.Set("thumbnail.jpg", imageBlob)`.)

>Note: A blob stored in the document's raw JSON as an object with a property `"_cbltype":"blob"`. It also has properties `"digest"` (a SHA-1 digest of the data), `"length"` (the length in bytes), and optionally `"type"` (the MIME type.) As always, the data is not stored in the document, but in a separate content-addressable store, indexed by the digest.

### Conflict Handling

We're approaching conflict handling differently, and more directly. Instead of requiring application code to go out of its way to find conflicts and look up the revisions involved, Couchbase Lite will detect the conflict (while saving a document, or during replication) and invoke an app-defined conflict-resolver handler. The conflict resolver is given "my" document properties, "their" document properties, and (if available) the properties of the common ancestor revision.

* When saving an `IDocument`, "my" properties will be the in-memory properties of the object, and "their" properties will be one ones already saved in the database (by some other application thread, or by the replicator.)
* During replication, "my" properties will be the ones in the local database, and "their" properties will be the ones coming from the server.

The resolver is responsible for returning the resulting properties that should be saved. There are of course a lot of ways to do this. By the time 2.0 is released we want to include some resolver implementations for common algorithms (like the popular "last writer wins" that just returns "my" properties.) The resolver can also give up by returning `null`, in which case the save fails with a "conflict" error. This can be appropriate if the merge needs to be done interactively or by user intervention.

A resolver can be specified either at the database or the document level. If a document doesn't have its own, the database's resolver will be used. If the database doesn't have one either (the default situation), a default algorithm is used that picks the revision with the larger number of changes in its history.

## Queries

Database queries have changed significantly. Instead of the map/reduce algorithm used in 1.x, they're now based on expressions, of the form “*return ____ from documents where ____, ordered by ____*”, with semantics based on Couchbase Server's N1QL query language. This is already pretty similar to LINQ.

> Note: We're still evaluating whether to support map/reduce in 2.0. We recognize that, although it has a learning curve, it can be very powerful. We would appreciate feedback on this.

There are several parts to specifying a query:

1. What document criteria to match (corresponding to the “`WHERE …`” clause in N1QL or SQL)
2. What properties (JSON or derived) of the documents to return (“`SELECT …`”)
3. What criteria to group rows together by (“`GROUP BY …`”)
4. Which grouped rows to include (“`HAVING …`”)
3. The sort order (“`ORDER BY …`”)

These all have defaults:

* If you don't specify criteria, all documents are returned
* If you don't specify properties to return, you just get the document ID and sequence number
* If you don't specify grouping, rows are not grouped
* If you don't specify what groups to include, all are included
* If you don't specify a sort order, the order is undefined

> Note: The query API does not yet support joins. This feature will be added in a future preview release.

### The Query API

We are still designing the cross-platform query API; it will appear in a future preview release. Unlike iOS, there is no built in string based query mechanism in C# so we lack the ability to include a platform specific query mechanism at this time (LINQ is dependent on strongly typed objects and the "model" API, which will need to be released first)
