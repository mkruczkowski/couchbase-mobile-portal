---
id: java-release-notes
title: Java release notes
permalink: references/couchbase-lite/release-notes/Java/index.html
---

## 1.3.1

**Enhancements**

- [**#1376**](https://github.com/couchbase/couchbase-lite-java-core/issues/1376) Implement `timeout` parameter for `_changes` REST API
- [**#1387**](https://github.com/couchbase/couchbase-lite-java-core/issues/1387) Support for _oidc_refresh response without ID token

**Bugs**

- [**#1296**](https://github.com/couchbase/couchbase-lite-java-core/issues/1296) Cordova - After putting Android app in background mode for a few hours, CB lite is unresponsive
- [**#1372**](https://github.com/couchbase/couchbase-lite-java-core/issues/1372) Router unable to route request to do_GET_DesignDocument (ForestDB)
- [**#1375**](https://github.com/couchbase/couchbase-lite-java-core/issues/1375) Reduce intermittently returns wrong results for 1.3.0-45
- [**#1379**](https://github.com/couchbase/couchbase-lite-java-core/issues/1379) MultipartDocumentReader: Attachment length cannot be parsed as Integer
- [**#1386**](https://github.com/couchbase/couchbase-lite-java-core/issues/1386) POST _replicate not create replicators when altering props beside type, target/source
- [**#1394**](https://github.com/couchbase/couchbase-lite-java-core/issues/1394) ViewsTest.testDeleteView() test failure
- [**#1399**](https://github.com/couchbase/couchbase-lite-java-core/issues/1399) Longpoll _changes on Listener does not respect timeout property

### Where to get it

You can download this release from [Couchbase.com](http://www.couchbase.com/nosql-databases/downloads#Couchbase_Mobile)

## 1.3

**Enhancements**

- [**#708**](https://github.com/couchbase/couchbase-lite-java-core/issues/708) Apache HTTP Client Removal/Deprecated in Android M.
- [**#820**](https://github.com/couchbase/couchbase-lite-java-core/issues/820) Filter out _removed revision from push replication
- [**#1054**](https://github.com/couchbase/couchbase-lite-java-core/issues/1054) Support POST /_changes in Listener
- [**#1057**](https://github.com/couchbase/couchbase-lite-java-core/issues/1057) Cbforest master branch version fails with many unit test (1.2.0-java -> master)
- [**#1097**](https://github.com/couchbase/couchbase-lite-java-core/issues/1097) After purging a doc, its rows are left behind in view indexes
- [**#1099**](https://github.com/couchbase/couchbase-lite-java-core/issues/1099) Docs in SQLite dbs never get pruned until entire db is compacted
- [**#1194**](https://github.com/couchbase/couchbase-lite-java-core/issues/1194) Fallback to GET when POST is not allowed to _changes
- [**#1207**](https://github.com/couchbase/couchbase-lite-java-core/issues/1207) TTL support
- [**#1222**](https://github.com/couchbase/couchbase-lite-java-core/issues/1222) Make SQLite one writer and one/multiple reader modes to avoid waiting connection.
- [**#1247**](https://github.com/couchbase/couchbase-lite-java-core/issues/1247) Add public API to add an existing revision (AKA new_edits=false, or -forceInsert:)
- [**#1255**](https://github.com/couchbase/couchbase-lite-java-core/issues/1255) Authenticator for OpenID Connect

**Bugs**

- [**#310**](https://github.com/couchbase/couchbase-lite-java-core/issues/310) Post on doc without data returns 404 instead of 405
- [**#667**](https://github.com/couchbase/couchbase-lite-java-core/issues/667) Using PipedInputStream and PipedOutputStream in URLConnection can cause deadlock (see issue 57 in couchbase-lite-java-listener)
- [**#880**](https://github.com/couchbase/couchbase-lite-java-core/issues/880) Query for view with map-reduce function and startkey doesn't work properly
- [**#891**](https://github.com/couchbase/couchbase-lite-java-core/issues/891) Fix failing tests (on Jenkins/VM)
- [**#952**](https://github.com/couchbase/couchbase-lite-java-core/issues/952) Views broken with concurrent update and delete
- [**#1015**](https://github.com/couchbase/couchbase-lite-java-core/issues/1015) NPE Attempt to invoke virtual method int com.couchbase.lite.Database.findMissingRevisions on a null object reference
- [**#1026**](https://github.com/couchbase/couchbase-lite-java-core/issues/1026) Change tracker stopping during replication exception
- [**#1037**](https://github.com/couchbase/couchbase-lite-java-core/issues/1037) Proxy setting on Android blocks access to Listener
- [**#1073**](https://github.com/couchbase/couchbase-lite-java-core/issues/1073) ForestDB CBL 1.2 random crash.
- [**#1090**](https://github.com/couchbase/couchbase-lite-java-core/issues/1090) Android API 10: java.lang.UnsatisfiedLinkError: nativeOpen
- [**#1091**](https://github.com/couchbase/couchbase-lite-java-core/issues/1091) ReplicationTest > testPusherBatching FAILED with CBL Java
- [**#1095**](https://github.com/couchbase/couchbase-lite-java-core/issues/1095) CBL 1.2 ForestDB random crash.
- [**#1098**](https://github.com/couchbase/couchbase-lite-java-core/issues/1098) Querying local CBLite via REST API returns all doc revisions (not just current rev)
- [**#1161**](https://github.com/couchbase/couchbase-lite-java-core/issues/1161) CBL - 1.2.0 upgrade from 1.1.0 clears device db
- [**#1176**](https://github.com/couchbase/couchbase-lite-java-core/issues/1176) ForestDB CBL 1.2  crash in endTransaction()
- [**#1177**](https://github.com/couchbase/couchbase-lite-java-core/issues/1177) ForestDB CBL 1.2 crash.
- [**#1193**](https://github.com/couchbase/couchbase-lite-java-core/issues/1193) Return 405 (Method Not Allowed) instead of 404 if Router does not support requested REST API
- [**#1196**](https://github.com/couchbase/couchbase-lite-java-core/issues/1196) Crash in ForestDB (filemgr_is_fully_resident)
- [**#1201**](https://github.com/couchbase/couchbase-lite-java-core/issues/1201) GrocerySync crashes with ForestDB
- [**#1210**](https://github.com/couchbase/couchbase-lite-java-core/issues/1210) Listener ?attachments=true to return attachment in base64
- [**#1211**](https://github.com/couchbase/couchbase-lite-java-core/issues/1211) Supports `only_conflicts` and `include_conflicts` query parameters for `_all_docs` REST API
- [**#1222**](https://github.com/couchbase/couchbase-lite-java-core/issues/1222) Make SQLite one writer and one/multiple reader modes to avoid waiting connection.
- [**#1227**](https://github.com/couchbase/couchbase-lite-java-core/issues/1227) Port: Crash when saving, conflict generated and infinite replication loop
- [**#1232**](https://github.com/couchbase/couchbase-lite-java-core/issues/1232) ManagerTest.testClose() failed with latest master branch
- [**#1235**](https://github.com/couchbase/couchbase-lite-java-core/issues/1235) BackFillTest.testPullReplWithRevsAndAtts() fails
- [**#1236**](https://github.com/couchbase/couchbase-lite-java-core/issues/1236) PullReplWithRevsAndAttsTest.testPullReplWithRevsAndAtts() fails
- [**#1241**](https://github.com/couchbase/couchbase-lite-java-core/issues/1241) Couchbase-lite-java-forestdb is not build-able on Windows
- [**#1243**](https://github.com/couchbase/couchbase-lite-java-core/issues/1243) Push replication from Android LiteServ and sync_gateway not pushing all deleted documents
- [**#1245**](https://github.com/couchbase/couchbase-lite-java-core/issues/1245) CBL Java/Android can not handle complex Accept: header value
- [**#1249**](https://github.com/couchbase/couchbase-lite-java-core/issues/1249) Purge does not update view on ForestDB Mobile
- [**#1263**](https://github.com/couchbase/couchbase-lite-java-core/issues/1263) Deleting a db takes over 1 min.
- [**#1264**](https://github.com/couchbase/couchbase-lite-java-core/issues/1264) Querying a design document view returns deleted documents too REST API
- [**#1270**](https://github.com/couchbase/couchbase-lite-java-core/issues/1270) Forestdb Handle is being used by another thread (Note: ForestDB error code = -39)
- [**#1272**](https://github.com/couchbase/couchbase-lite-java-core/issues/1272) 400 Missing data of attachment while pushing attachments
- [**#1275**](https://github.com/couchbase/couchbase-lite-java-core/issues/1275) Very slow doc PUT's with lots of garbage collection.
- [**#1276**](https://github.com/couchbase/couchbase-lite-java-core/issues/1276) ForestDB CBL crash.
- [**#1285**](https://github.com/couchbase/couchbase-lite-java-core/issues/1285) OkHttp ConnectionPool thread leaking
- [**#1289**](https://github.com/couchbase/couchbase-lite-java-core/issues/1289) SecureTokenStore does not work with  Android M/N and there is encrypting data size limitation for API 18 - 22
- [**#1297**](https://github.com/couchbase/couchbase-lite-java-core/issues/1297) 590 Database error (Note: ForestDB error code = -39)
- [**#1299**](https://github.com/couchbase/couchbase-lite-java-core/issues/1299) Get just attachment with header 'Accept: applicatio/json'  should return {"status" : 406, "error" : "not_acceptable"}
- [**#1300**](https://github.com/couchbase/couchbase-lite-java-core/issues/1300) Compaction doesn't work with ForestDb
- [**#1301**](https://github.com/couchbase/couchbase-lite-java-core/issues/1301) ForestDB throws exception from native call (Note: ForestDB error code = -39)
- [**#1308**](https://github.com/couchbase/couchbase-lite-java-core/issues/1308) Encrypted attachments fail to sync
- [**#1315**](https://github.com/couchbase/couchbase-lite-java-core/issues/1315) Replicator shouldn't go to IDLE state if the authenticating is not done
- [**#1319**](https://github.com/couchbase/couchbase-lite-java-core/issues/1319) Autopruning failing on pull replication
- [**#1324**](https://github.com/couchbase/couchbase-lite-java-core/issues/1324) OIDC shouldn't clear refresh token after refreshing the token
- [**#1332**](https://github.com/couchbase/couchbase-lite-java-core/issues/1332) Cancelling a replication does not return a response.
- [**#1333**](https://github.com/couchbase/couchbase-lite-java-core/issues/1333) OIDC: Obtaining username with refresh-token might have issue
- [**#1339**](https://github.com/couchbase/couchbase-lite-java-core/issues/1339) Make lower initial heartbeat value for /_changes REST API
- [**#1342**](https://github.com/couchbase/couchbase-lite-java-core/issues/1342) Unit Test Failures on Jenkins
- [**#1355**](https://github.com/couchbase/couchbase-lite-java-core/issues/1355) Listener does not return response for PUT /db
- [**#1356**](https://github.com/couchbase/couchbase-lite-java-core/issues/1356) Listener does not return response for DELETE /db
- [**#1367**](https://github.com/couchbase/couchbase-lite-java-core/issues/1367) Live Query Seems broken with ForestDB

### Where to get it

You can download this release from [Couchbase.com](http://www.couchbase.com/nosql-databases/downloads#Couchbase_Mobile)
