---
id: sg-release-notes
title: SG release notes
permalink: references/sync-gateway/release-notes/index.html
---

## 1.3.1 release

**Enhancements**

- [**#1745**](https://github.com/couchbase/sync_gateway/issues/1745) Add retry when trying to connect to a server node in "warmup" state
- [**#2005**](https://github.com/couchbase/sync_gateway/issues/2005) Tombstones don't grant access, don't propagate to users granted access by the doc
- [**#2013**](https://github.com/couchbase/sync_gateway/issues/2013) Azure returns unsigned ID token in response to refresh request
- [**#2038**](https://github.com/couchbase/sync_gateway/issues/2038) Uptake expvar refactoring for perf usage into 1.3.1
- [**#2046**](https://github.com/couchbase/sync_gateway/issues/2046) Service install script enhancement for Ubuntu 16.04

**Bugs**

- [**#973**](https://github.com/couchbase/sync_gateway/issues/973) Can't initiate websocket connection
- [**#1554**](https://github.com/couchbase/sync_gateway/issues/1554) Panic: send on closed channel when closing database
- [**#1999**](https://github.com/couchbase/sync_gateway/issues/1999) Sync Gateway terminating changes requests

### Where to get it

You can download this release from [Couchbase.com](http://www.couchbase.com/nosql-databases/downloads#Couchbase_Mobile)


## 1.3 release

__Performance Improvements__

- [__#1631__](https://github.com/couchbase/sync_gateway/issues/1631) Disable assimilator when autoImport=false and shadower=nil
- [__#1752__](https://github.com/couchbase/sync_gateway/issues/1752) Major inefficiencies replicating docs with many revisions

__Enhancements__

- [__#508__](https://github.com/couchbase/sync_gateway/issues/508) Feature Request:  Oauth2 Support
- [__#656__](https://github.com/couchbase/sync_gateway/issues/656) Special characters in channel names cause error
- [__#1326__](https://github.com/couchbase/sync_gateway/issues/1326) Map URI's without a trailing slash to the same handlers as the trailing backslash routes
- [__#1331__](https://github.com/couchbase/sync_gateway/issues/1331) Create and distribute a diagnostics tool
- [__#1623__](https://github.com/couchbase/sync_gateway/issues/1623) POST to _changes is incompatible with CouchDB's implementation
- [__#1634__](https://github.com/couchbase/sync_gateway/issues/1634) Querying a view via the Public REST API returns total row count
- [__#1663__](https://github.com/couchbase/sync_gateway/issues/1663) Add `_replicate` support to SG admin REST API
- [__#1680__](https://github.com/couchbase/sync_gateway/issues/1680) SGW /{db}/{doc}?revs_info=true doesn't show revision info
- [__#1683__](https://github.com/couchbase/sync_gateway/issues/1683) Allow forward slashes in attachment names
- [__#1685__](https://github.com/couchbase/sync_gateway/issues/1685) Misleading error message when trying to add attachment to unavailable document
- [__#1686__](https://github.com/couchbase/sync_gateway/issues/1686) New logging REST API endpoint
- [__#1688__](https://github.com/couchbase/sync_gateway/issues/1688) Implement OpenID Connect relying-party support
- [__#1710__](https://github.com/couchbase/sync_gateway/issues/1710) Ability for Sync Gateway to bring itself back online after unexpected offline
- [__#1774__](https://github.com/couchbase/sync_gateway/issues/1774) Functional tests for OIDC authentication
- [__#1926__](https://github.com/couchbase/sync_gateway/issues/1926) Handle invalid username characters in OIDC issuer, subject

__Bugs__

- [__#1024__](https://github.com/couchbase/sync_gateway/issues/1024) Sync Gateway not reporting changes
- [__#1034__](https://github.com/couchbase/sync_gateway/issues/1034) SyncGateway not looking up the ancestry to find an attachment
- [__#1051__](https://github.com/couchbase/sync_gateway/issues/1051) Couchbase Server indexing stuck on SG views
- [__#1286__](https://github.com/couchbase/sync_gateway/issues/1286) Removing a node from CB-cluster and rebalance causing writer SG to crash
- [__#1308__](https://github.com/couchbase/sync_gateway/issues/1308) [Distributed Index] User not getting docs in  _changes when given access via sync function
- [__#1384__](https://github.com/couchbase/sync_gateway/issues/1384) Changes feed returning duplicates for * channel
- [__#1388__](https://github.com/couchbase/sync_gateway/issues/1388) [Distributed Index] Panic when restarting sync_gateway
- [__#1471__](https://github.com/couchbase/sync_gateway/issues/1471) [Distributed Index] Panic when shutting down sg_accel while it is indexing
- [__#1575__](https://github.com/couchbase/sync_gateway/issues/1575) New warning happening on SG 1.2: "MultiChangesFeed: Terminator missing for Continuous/Wait mode"
- [__#1631__](https://github.com/couchbase/sync_gateway/issues/1631) Disable assimilator when autoImport=false and shadower=nil
- [__#1656__](https://github.com/couchbase/sync_gateway/issues/1656) Users can be created with empty password even though `allow_empty_password` is `False`
- [__#1691__](https://github.com/couchbase/sync_gateway/issues/1691) Latest gocb breaks go get
- [__#1702__](https://github.com/couchbase/sync_gateway/issues/1702) _changes with doc_ids filter does not return deleted docs
- [__#1706__](https://github.com/couchbase/sync_gateway/issues/1706) Attachments fail to sync if revpos ancestor on server has been compacted
- [__#1712__](https://github.com/couchbase/sync_gateway/issues/1712) Return an error for unsupported changes filter
- [__#1728__](https://github.com/couchbase/sync_gateway/issues/1728) Attachments still stored for documents rejected by sync function
- [__#1736__](https://github.com/couchbase/sync_gateway/issues/1736) Intermittent unit test failure - TestPostChangesChannelFilterClock
- [__#1751__](https://github.com/couchbase/sync_gateway/issues/1751) SG master doesn't compile on i386
- [__#1760__](https://github.com/couchbase/sync_gateway/issues/1760) Compiling for i386 fails in `pruneRevisions`
- [__#1769__](https://github.com/couchbase/sync_gateway/issues/1769) Filter by channel works with arrays only
- [__#1857__](https://github.com/couchbase/sync_gateway/issues/1857) Changes feed with doc_ids filter omits `deleted` properties

__Known Issues__

- [__#1979__](https://github.com/couchbase/sync_gateway/issues/1979) OIDC - Azure AD must be default provider when using multiple providers

### Where to get it

You can download this release from the [downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).