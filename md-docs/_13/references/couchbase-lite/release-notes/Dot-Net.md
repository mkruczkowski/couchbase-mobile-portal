---
id: dot-net-release-notes
title: .NET release notes
permalink: references/couchbase-lite/release-notes/Dot-Net/index.html
---

## 1.3.1

**Bugs**

- [**#693**](https://github.com/couchbase/couchbase-lite-net/issues/693) TestJSViews failing with ForestDB
- [**#716**](https://github.com/couchbase/couchbase-lite-net/issues/716) V1.3 Unauthorized http state not reported on replicators LastError property
- [**#717**](https://github.com/couchbase/couchbase-lite-net/issues/717) Unexpected replications returned from active tasks
- [**#723**](https://github.com/couchbase/couchbase-lite-net/issues/723) POST _replicate fails which when "source" or "target" is a dictionary

### Where to get it

You can download this release from [Couchbase.com](http://www.couchbase.com/nosql-databases/downloads#Couchbase_Mobile)

## 1.3

**Enhancements**

- [**#50**](https://github.com/couchbase/couchbase-lite-net/issues/50) Add WebSocket support to replication
- [**#558**](https://github.com/couchbase/couchbase-lite-net/issues/558) Missing PrefixMatchLevel under query
- [**#570**](https://github.com/couchbase/couchbase-lite-net/issues/570) Implement Database.Close()
- [**#574**](https://github.com/couchbase/couchbase-lite-net/issues/574) Remove requirement to define SQLCIPHER
- [**#582**](https://github.com/couchbase/couchbase-lite-net/issues/582) Stop using long poll limit
- [**#595**](https://github.com/couchbase/couchbase-lite-net/issues/595) Support POST /_changes in listener
- [**#596**](https://github.com/couchbase/couchbase-lite-net/issues/596) Package 32-bit CBForest-Interop.dll
- [**#599**](https://github.com/couchbase/couchbase-lite-net/issues/599) Allow users to specify the format they want dates to be deserialized as
- [**#606**](https://github.com/couchbase/couchbase-lite-net/issues/606) Implement remote logging interface
- [**#613**](https://github.com/couchbase/couchbase-lite-net/issues/613) Make View.UpdateIndex() public
- [**#615**](https://github.com/couchbase/couchbase-lite-net/issues/615) Hook up GET _active_tasks
- [**#617**](https://github.com/couchbase/couchbase-lite-net/issues/617) TTL support
- [**#634**](https://github.com/couchbase/couchbase-lite-net/issues/634) No way to remove a database.
- [**#635**](https://github.com/couchbase/couchbase-lite-net/issues/635) Add support for HTTP 408 status
- [**#639**](https://github.com/couchbase/couchbase-lite-net/issues/639) Provide build of ListenerConsole in latestbuilds with each nuget package set.
- [**#648**](https://github.com/couchbase/couchbase-lite-net/issues/648) Major inefficiencies replicating docs with many revisions
- [**#650**](https://github.com/couchbase/couchbase-lite-net/issues/650) Investigate ability to more quickly start a stopping replication
- [**#652**](https://github.com/couchbase/couchbase-lite-net/issues/652) OpenID connect mechanism
- [**#653**](https://github.com/couchbase/couchbase-lite-net/issues/653) REST API for TTL
- [**#678**](https://github.com/couchbase/couchbase-lite-net/issues/678) Implement GET design doc
- [**#685**](https://github.com/couchbase/couchbase-lite-net/issues/685) Add API for clearing OpenID auth token
- [**#686**](https://github.com/couchbase/couchbase-lite-net/issues/686) OpenID tokens in the key store should be per-database

**Bugs**

- [**#557**](https://github.com/couchbase/couchbase-lite-net/issues/557) SimpleAndroidSync freezing when adding items offline
- [**#573**](https://github.com/couchbase/couchbase-lite-net/issues/573) Implement query filter on ForestDB views
- [**#580**](https://github.com/couchbase/couchbase-lite-net/issues/580) Prevent nuget from using incompatible Stateless versions
- [**#583**](https://github.com/couchbase/couchbase-lite-net/issues/583) System.BadImageFormatException when calling manager.GetDatabase("dbname") method
- [**#590**](https://github.com/couchbase/couchbase-lite-net/issues/590) Listener crashes when receiving improper messages
- [**#591**](https://github.com/couchbase/couchbase-lite-net/issues/591) Warn if map function calls emit(null, ...)
- [**#608**](https://github.com/couchbase/couchbase-lite-net/issues/608) Listener intermittently enters hanging state
- [**#609**](https://github.com/couchbase/couchbase-lite-net/issues/609) After purging a doc, live queries are not informed of the view change
- [**#610**](https://github.com/couchbase/couchbase-lite-net/issues/610) Docs in SQLite dbs never get pruned until entire db is compacted
- [**#611**](https://github.com/couchbase/couchbase-lite-net/issues/611) Stop() should not wait for changes to finish
- [**#612**](https://github.com/couchbase/couchbase-lite-net/issues/612) When examining an exception, all nested exceptions should be examined
- [**#616**](https://github.com/couchbase/couchbase-lite-net/issues/616) ExecSQL timeout prevents successful query of a very large db
- [**#623**](https://github.com/couchbase/couchbase-lite-net/issues/623) Pushing ending prematurely
- [**#625**](https://github.com/couchbase/couchbase-lite-net/issues/625) Xamarin Android crash due to hitting max application memory while syncing large attachments
- [**#627**](https://github.com/couchbase/couchbase-lite-net/issues/627) Revpos == 0 needs to be treated as valid
- [**#628**](https://github.com/couchbase/couchbase-lite-net/issues/628) Fallback to GET when POST is not allowed to _changes
- [**#631**](https://github.com/couchbase/couchbase-lite-net/issues/631) Duplicate rows emitted during UpdateIndex
- [**#636**](https://github.com/couchbase/couchbase-lite-net/issues/636) Starting a replication that already exists causes NRE
- [**#637**](https://github.com/couchbase/couchbase-lite-net/issues/637) IOS device build error in 1.2.1.1
- [**#640**](https://github.com/couchbase/couchbase-lite-net/issues/640) Docs taking a really long time to replicate
- [**#641**](https://github.com/couchbase/couchbase-lite-net/issues/641) 401 Unauthorized during replication
- [**#643**](https://github.com/couchbase/couchbase-lite-net/issues/643) Manager constructor fails on Windows 10
- [**#644**](https://github.com/couchbase/couchbase-lite-net/issues/644) Heartbeat not behaving correctly with Listener (not honoring user setting)
- [**#654**](https://github.com/couchbase/couchbase-lite-net/issues/654) Change tracker paused not working
- [**#655**](https://github.com/couchbase/couchbase-lite-net/issues/655) Web socket change tracker doesn't use auth
- [**#656**](https://github.com/couchbase/couchbase-lite-net/issues/656) Delete replications not following the same behavior as the native iOS library
- [**#657**](https://github.com/couchbase/couchbase-lite-net/issues/657) Documents with null _attachments property cause NullReferenceException
- [**#659**](https://github.com/couchbase/couchbase-lite-net/issues/659) Document.Update enters infinite loop
- [**#660**](https://github.com/couchbase/couchbase-lite-net/issues/660) Setting log configuration via app.config is throwing exception
- [**#661**](https://github.com/couchbase/couchbase-lite-net/issues/661) Removed attachments reported by UnsavedRevision
- [**#666**](https://github.com/couchbase/couchbase-lite-net/issues/666) Unsaved attachment ContentType property throws NullReferenceException
- [**#667**](https://github.com/couchbase/couchbase-lite-net/issues/667) WebSocketChangeTracker does not support using cookies for authentication
- [**#669**](https://github.com/couchbase/couchbase-lite-net/issues/669) POST _replicate on the listen does not returns null "session_id"
- [**#673**](https://github.com/couchbase/couchbase-lite-net/issues/673) Incorrect processing in REST API of documents with null bodies
- [**#674**](https://github.com/couchbase/couchbase-lite-net/issues/674) Needless exception thrown and caught when dynamic DLL is loaded
- [**#675**](https://github.com/couchbase/couchbase-lite-net/issues/675) Incorrect class type causing issues with REST all documents query
- [**#676**](https://github.com/couchbase/couchbase-lite-net/issues/676) Rare continuous changes feed issue over SSL
- [**#679**](https://github.com/couchbase/couchbase-lite-net/issues/679) Functional test failure on auto pruning
- [**#683**](https://github.com/couchbase/couchbase-lite-net/issues/683) Fail to GET encrypted raw attachment
- [**#687**](https://github.com/couchbase/couchbase-lite-net/issues/687) Pusher not properly setting headers on HTTP requests
- [**#688**](https://github.com/couchbase/couchbase-lite-net/issues/688) Null reference exception during functional auto prune test
- [**#694**](https://github.com/couchbase/couchbase-lite-net/issues/694) Xamarin Android SIGSEGV on unit test
- [**#698**](https://github.com/couchbase/couchbase-lite-net/issues/698) NullReferenceException in SendAsyncRequest
- [**#705**](https://github.com/couchbase/couchbase-lite-net/issues/705) Replication unable to recover from remote checkpoint conflict

**Known Issues**

- [**#693**](https://github.com/couchbase/couchbase-lite-net/issues/693) TestJSViews failing with ForestDB

### Where to get it

You can download this release from [Couchbase.com](http://www.couchbase.com/nosql-databases/downloads#Couchbase_Mobile)