---
id: sg-release-notes
title: SG release notes
---

## 1.4.1 release

__Enhancements__

- [__#2373__](https://github.com/couchbase/sync_gateway/issues/2373) Add sample config for SG running with Accel
- [__#2428__](https://github.com/couchbase/sync_gateway/issues/2428) Avoid document body unmarshalling on changes requests

__Bugs__

- [__#1518__](https://github.com/couchbase/sync_gateway/issues/1518) Data races detected in channel_cache.go
- [__#2364__](https://github.com/couchbase/sync_gateway/issues/2364) Omit doc during Changes+ logging
- [__#2365__](https://github.com/couchbase/sync_gateway/issues/2365) Account for unused sequences after CAS retry and subsequent cancel
- [__#2427__](https://github.com/couchbase/sync_gateway/issues/2427) CBSE: Data race in trimEncodedRevisionsToAncestor

## 1.4 release

__New features__

- [Sync Gateway Accelerator](../../guides/sync-gateway/accelerator.html)
- [Log rotation](../../guides/sync-gateway/deployment/index.html#built-in-log-rotation)

__Performance Improvements__

- [__#1514__](https://github.com/couchbase/sync_gateway/issues/1514) Run long-running performance tests against 1.4

__Enhancements__

- [__#1713__](https://github.com/couchbase/sync_gateway/issues/1713) [sg-accel] Use reference counts to track active channels
- [__#1925__](https://github.com/couchbase/sync_gateway/issues/1925) HTTP basic auth for webhooks
- [__#2098__](https://github.com/couchbase/sync_gateway/issues/2098) Upgrade build to go 1.7.1
- [__#2160__](https://github.com/couchbase/sync_gateway/issues/2160) Add log rotation capabilities into Sync Gateway
- [__#2255__](https://github.com/couchbase/sync_gateway/issues/2255) Update sgcollect_info to collect logs defined logging config
- [__#2298__](https://github.com/couchbase/sync_gateway/issues/2298) Update sgcollect_info to capture rotated logs

__Bugs__

- [__#1529__](https://github.com/couchbase/sync_gateway/issues/1529) Longpoll _changes request that returns no results, returns invalid sequence number for last_seq
- [__#1865__](https://github.com/couchbase/sync_gateway/issues/1865) One shot replication of granting access doc can lead to miss documents
- [__#1890__](https://github.com/couchbase/sync_gateway/issues/1890) Calling db _online when CBS bucket is not available results in "no such database" even when CBS bucket is available again
- [__#2080__](https://github.com/couchbase/sync_gateway/issues/2080) Startup error when config includes unsupported/user_views
- [__#2084__](https://github.com/couchbase/sync_gateway/issues/2084) Update Windows install folder for sg_accel
- [__#2102__](https://github.com/couchbase/sync_gateway/issues/2102) Protect against empty doc body in handlePutDoc
- [__#2139__](https://github.com/couchbase/sync_gateway/issues/2139) Sg_accel packages should use example config from sync-gateway-accel repo
- [__#2159__](https://github.com/couchbase/sync_gateway/issues/2159) Handle channel removal for coalesced feed updates
- [__#2187__](https://github.com/couchbase/sync_gateway/issues/2187) SG panic when upgrading keepalive http connection to WebSockets
- [__#2212__](https://github.com/couchbase/sync_gateway/issues/2212) Channel filtered sg-replicate stops due to channel removals
- [__#2270__](https://github.com/couchbase/sync_gateway/issues/2270) Starting sync gateway from command line does not always report the right status

__Known Issues__

- [__#2341__](https://github.com/couchbase/sync_gateway/issues/2341) Channel_index bucket authentication requires username

__Deprecation notices__

The following features are being deprecated in 1.4 and will be unsupported in an upcoming version (2.x) of Couchbase 
Mobile.

- Bucket Shadowing

## Where to get it

You can download this release from the [downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).