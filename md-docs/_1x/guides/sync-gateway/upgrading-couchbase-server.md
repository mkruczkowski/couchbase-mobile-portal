
## Upgrading a Couchbase Server cluster used by Sync Gateway

There are two overall approaches to upgrading the Couchbase Server cluster that is used by Sync Gateway:

1. Shutdown Sync Gateway during Couchbase Server upgrade
1. Keep Sync Gateway running during Couchbase Server upgrade

### Shutdown Sync Gateway during Couchbase Server upgrade

This is the preferred approach, as there is no chance of data loss or transient connection issues.  The tradeoff is that it will result in more Sync Gateway downtime.

1. Take Sync Gateway offline
1. Upgrade Couchbase Server using any of the options mentioned in the [Upgrading Couchbase Server](https://developer.couchbase.com/documentation/server/4.1/install/upgrading.html) documentation.  
1. Bring Sync Gateway online

### Keep Sync Gateway running during Couchbase Server upgrade

This approach will have less Sync Gateway downtime, but runs a higher risk of data loss or transient connection issues.

1. Do an [Online Upgrade](https://developer.couchbase.com/documentation/server/4.1/install/upgrade-online.html) of Couchbase Server and wait until completion
1. Do a rolling restart of the Sync Gateway nodes

The rolling restart of the Sync Gateway nodes is needed because there is a chance the Sync Gateway nodes could lose the mutation feed (TAP or DCP) along the way.

#### XDCR-based upgrade

While not technically an [Online Upgrade](https://developer.couchbase.com/documentation/server/4.1/install/upgrade-online.html), it should be possible to use XDCR (Cross Data Center Replication) to migrate to a new Couchbase Server cluster running on a newer version, while having minimal downtime:

1. Start XDCR to do a one way replication from the existing (source) Couchbase Server cluster to the new (target) Couchbase Server cluster running the newer version
1. Shutdown Sync Gateway to prevent any new writes from coming in
1. Wait until the target Couchbase Server has caught up to all the writes in the source Couchbase Server cluster
1. Restart Sync Gateway, configured to run against the target Couchbase Server



