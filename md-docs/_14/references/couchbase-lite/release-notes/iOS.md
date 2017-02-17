---
id: ios-release-notes
title: iOS release notes
---

As part of this release we had [17 issues](https://github.com/couchbase/couchbase-lite-ios/issues?milestone=18&state=closed) closed.
Early-2017 update focusing mostly on bug-fixes.

__API change__

- An `isDeletion` property is now available on the `DatabaseChange` object to identify if a change is tombstone document.

__Performance Improvements__

- [__#1389__](https://github.com/couchbase/couchbase-lite-ios/issues/1389) Allow SQLite reads concurrently with writer
- [__#1497__](https://github.com/couchbase/couchbase-lite-ios/issues/1497) Update ForestDB to get improved compaction / space reuse

__Enhancements__

- [__#1538__](https://github.com/couchbase/couchbase-lite-ios/issues/1538) Make CBLDatabaseChange.isDeletion public?

__Bugs__

- [__#794__](https://github.com/couchbase/couchbase-lite-ios/issues/794) "!_changeTracker" assertion failure in -[CBLRestPuller startChangeTracker]
- [__#1207__](https://github.com/couchbase/couchbase-lite-ios/issues/1207) Push replication stops with error `400 bad_request`
- [__#1243__](https://github.com/couchbase/couchbase-lite-ios/issues/1243) Replication task missing source or target values
- [__#1285__](https://github.com/couchbase/couchbase-lite-ios/issues/1285) REST API does not allow GET on a db with "/" in its name
- [__#1343__](https://github.com/couchbase/couchbase-lite-ios/issues/1343) Need to close all other db handles before rekeying
- [__#1365__](https://github.com/couchbase/couchbase-lite-ios/issues/1365) Non-continuous push replication gets stuck in kCBLReplicationIdle status
- [__#1422__](https://github.com/couchbase/couchbase-lite-ios/issues/1422) ForestDB crashes frequently in the background because of protection data level
- [__#1429__](https://github.com/couchbase/couchbase-lite-ios/issues/1429) 1.3.1-6: crashed EXC_BAD_ACCESS KERN_INVALID_ADDRESS 0x0000000000000000
- [__#1442__](https://github.com/couchbase/couchbase-lite-ios/issues/1442) Collection class properties not propagating from CBLDocument to CBLModel after sync
- [__#1443__](https://github.com/couchbase/couchbase-lite-ios/issues/1443) Handle iOS file protection gracefully when in background
- [__#1461__](https://github.com/couchbase/couchbase-lite-ios/issues/1461) ForestDB: Assertion failure in -[MYBackgroundMonitor beginBackgroundTaskNamed:]() MYBackgroundMonitor.m:66
- [__#1467__](https://github.com/couchbase/couchbase-lite-ios/issues/1467) Memory leak caused by ref cycle between replicator and CBLRemoteSession

__Deprecation notices__

The following features are being deprecated in Couchbase Mobile 1.4 and will be unsupported in 2.0.

- ForestDB
- Geo queries

The following platforms are being deprecated in Couchbase Mobile 1.4 and will be unsupported in 2.0.

- iOS 8

## Where to get it

You can download this release from the [downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).