---
id: java-release-notes
title: Java release notes
---

As part of this release we had [96 commits](https://github.com/couchbase/couchbase-lite-java-core/compare/1.3.1...1.4.0) which resulted in [24 issues](https://github.com/couchbase/couchbase-lite-java-core/issues?milestone=13&state=closed) being closed.


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

## Where to get it
You can download this release from [Couchbase.com](http://www.couchbase.com/nosql-databases/downloads#Couchbase_Mobile)