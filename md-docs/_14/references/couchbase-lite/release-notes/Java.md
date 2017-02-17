---
id: java-release-notes
title: Java release notes
---

As part of this release we had [110 commits](https://github.com/couchbase/couchbase-lite-java-core/compare/1.3.1...1.4.0) which resulted in [30 issues](https://github.com/couchbase/couchbase-lite-java-core/issues?milestone=13&state=closed) being closed.

__API change__

- An `isDeletion` property is now available on the `DatabaseChange` object to identify if a change is tombstone document.

__Enhancements__

- [__#1087__](https://github.com/couchbase/couchbase-lite-java-core/issues/1087) LiteServ app for Java
- [__#1543__](https://github.com/couchbase/couchbase-lite-java-core/issues/1543) Make CBLDatabaseChange.isDeletion public?
- [__#1554__](https://github.com/couchbase/couchbase-lite-java-core/issues/1554) 1.0.2d is being rejected by Google Play

__Bugs__

- [__#911__](https://github.com/couchbase/couchbase-lite-java-core/issues/911) Multiple duplicate replication change events sent in pull replication
- [__#1334__](https://github.com/couchbase/couchbase-lite-java-core/issues/1334) Change tracker stopped during continuous replication error thrown when cookie expires
- [__#1385__](https://github.com/couchbase/couchbase-lite-java-core/issues/1385) CBLReplicatorExecutor still exists after stopping the replicator
- [__#1470__](https://github.com/couchbase/couchbase-lite-java-core/issues/1470) IOS pull replication from Android
- [__#1471__](https://github.com/couchbase/couchbase-lite-java-core/issues/1471) Attachments failed to replicate when deleted and recreated
- [__#1481__](https://github.com/couchbase/couchbase-lite-java-core/issues/1481) ConnectionError: ('Connection aborted.', error(54, 'Connection reset by peer'))
- [__#1493__](https://github.com/couchbase/couchbase-lite-java-core/issues/1493) Test failure ViewsTest.failingTestAllDocumentsLiveQuery on Jenkins
- [__#1495__](https://github.com/couchbase/couchbase-lite-java-core/issues/1495) Changes feed skipping changes on rapid long poll
- [__#1498__](https://github.com/couchbase/couchbase-lite-java-core/issues/1498) Was not able to delete the database directory, Status: 500 (HTTP 500 Internal Server Error)
- [__#1510__](https://github.com/couchbase/couchbase-lite-java-core/issues/1510) Mixing HashMap and TreeMap for properties in Document. HashMap allows to generate non-canonical JSON.
- [__#1534__](https://github.com/couchbase/couchbase-lite-java-core/issues/1534) Push Replication Fails With createTarget Set
- [__#1535__](https://github.com/couchbase/couchbase-lite-java-core/issues/1535) ForestDB Views Issue :Router: Router unable to route request to do_GET_DesignDocument(java.lang.NullPointerException)
- [__#1540__](https://github.com/couchbase/couchbase-lite-java-core/issues/1540) _replicate REST API with one-shot returns immediately.
- [__#1549__](https://github.com/couchbase/couchbase-lite-java-core/issues/1549) 1.4-12 ConnectionError: ('Connection aborted.', error(54, 'Connection reset by peer')) during doc add
- [__#1550__](https://github.com/couchbase/couchbase-lite-java-core/issues/1550) Test Failure: testAndroid2MLimit
- [__#1551__](https://github.com/couchbase/couchbase-lite-java-core/issues/1551) Test failure: testMultipleLiveQueries
- [__#1552__](https://github.com/couchbase/couchbase-lite-java-core/issues/1552) P2P fails between android and macosx
- [__#1553__](https://github.com/couchbase/couchbase-lite-java-core/issues/1553) Test Failure: testGetDocumentWithLargeJSON
- [__#1558__](https://github.com/couchbase/couchbase-lite-java-core/issues/1558) Listener returning different error codes for negative tests 1.3.1 vs 1.4
- [__#1563__](https://github.com/couchbase/couchbase-lite-java-core/issues/1563) Database deletion failing with 1.4-25
- [__#1564__](https://github.com/couchbase/couchbase-lite-java-core/issues/1564) P2P sanity test failing
- [__#1575__](https://github.com/couchbase/couchbase-lite-java-core/issues/1575) SSL with allowSelfSignedSSLCertificates() method
- [__#1581__](https://github.com/couchbase/couchbase-lite-java-core/issues/1581) Replication failures when running Sync Gateway in distributed index
- [__#1589__](https://github.com/couchbase/couchbase-lite-java-core/issues/1589) Investigate possible push replication issue
- [__#1593__](https://github.com/couchbase/couchbase-lite-java-core/issues/1593) Missing changes on changes feed (Mac <- Android) pull replication
- [__#1595__](https://github.com/couchbase/couchbase-lite-java-core/issues/1595) Database error with peer-2-peer-sanity test
- [__#1597__](https://github.com/couchbase/couchbase-lite-java-core/issues/1597) P2P - ForestDB Error: forceInsert()

__Deprecation notices__

The following features are being deprecated in Couchbase Mobile 1.4 and will be unsupported in 2.0.

- ForestDB

The following platforms are being deprecated in Couchbase Mobile 1.4 and will be unsupported in 2.0.

- Android API Level < 16 

## Where to get it

You can download this release from the [downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).