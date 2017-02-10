---
id: sg-release-notes
title: SG release notes
---

As part of this release we had [78 commits](https://github.com/couchbase/sync_gateway/compare/1.3.1...1.4.0) which resulted in [19 issues](https://github.com/couchbase/sync_gateway/issues?milestone=19&state=closed) being closed.

__New features__

- [Sync Gateway Accelerator](../../guides/sync-gateway/accelerator.html)
- [Log rotation](../../guides/sync-gateway/log-rotation.html)

__Enhancements__

- [__#1030__](https://github.com/couchbase/sync_gateway/issues/1030) Add index compaction for distributed index
- [__#1105__](https://github.com/couchbase/sync_gateway/issues/1105) Support expiry values longer than 30 days for clock hash values
- [__#1211__](https://github.com/couchbase/sync_gateway/issues/1211) [distributed index] Rollback handling when indexing has proceeded past rollback sequence
- [__#1713__](https://github.com/couchbase/sync_gateway/issues/1713) [sg-accel] Use reference counts to track active channels
- [__#1925__](https://github.com/couchbase/sync_gateway/issues/1925) HTTP basic auth for webhooks

__Bugs__

- [__#1137__](https://github.com/couchbase/sync_gateway/issues/1137) [Distributed index] CBGT config validation
- [__#1227__](https://github.com/couchbase/sync_gateway/issues/1227) [distributed index] Channel removal notification and DCP deduplication
- [__#1371__](https://github.com/couchbase/sync_gateway/issues/1371) Not storing OpaqueSet values causes Sync Gateway panic during CBGT reshard
- [__#1523__](https://github.com/couchbase/sync_gateway/issues/1523) Panic in sync_gateway if db is over capacity (sequence rollback, sg_accel)
- [__#1529__](https://github.com/couchbase/sync_gateway/issues/1529) Longpoll _changes request that returns no results, returns invalid sequence number for last_seq
- [__#1566__](https://github.com/couchbase/sync_gateway/issues/1566) Sg-accel-service.go has 'Accelerator Accelerator' in descriptors
- [__#1865__](https://github.com/couchbase/sync_gateway/issues/1865) One shot replication of granting access doc can lead to miss documents
- [__#2080__](https://github.com/couchbase/sync_gateway/issues/2080) Startup error when config includes unsupported/user_views
- [__#2139__](https://github.com/couchbase/sync_gateway/issues/2139) Sg_accel packages should use example config from sync-gateway-accel repo

__Deprecation notices__

The following features are being deprecated in 1.4 and will be unsupported in an upcoming version (2.x) of Couchbase 
Mobile.

- Bucket Shadowing

## Where to get it

You can download this release from the [downloads page](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile).