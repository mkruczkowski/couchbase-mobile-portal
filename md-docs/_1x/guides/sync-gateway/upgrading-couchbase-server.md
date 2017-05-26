
# Upgrading a Couchbase Server cluster used by Sync Gateway

There are several overall approaches to upgrading the Couchbase Server cluster that is used by Sync Gateway:

| Upgrade Strategy  | Downtime | Risk Level | Additional Machine Requirements 
| ------------- | ------------- | ------------- | ------------- |
| Offline Upgrade  | During entire upgrade  | Very Low  | None  |
| Replication Upgrade  | Small amount during switchover  | Low  | High - duplicate entire cluster |
| Online Upgrade  | None  | Medium  | Low - at least one extra machine required |

## Offline Upgrade

1. Take Sync Gateway offline
1. Upgrade Couchbase Server using any of the options mentioned in the [Upgrading Couchbase Server](https://developer.couchbase.com/documentation/server/4.1/install/upgrading.html) documentation.  
1. Bring Sync Gateway online

## Replication Upgrade

Using an XDCR (Cross Data Center Replication) approach will have incur some Sync Gateway downtime, but less downtime than other approaches where Sync Gateway is shutdown during the entire Couchbase Server upgrade.

1. Start XDCR to do a one way replication from the existing (source) Couchbase Server cluster to the new (target) Couchbase Server cluster running the newer version.
1. Wait until the target Couchbase Server has caught up to all the writes in the source Couchbase Server cluster.
1. Shutdown Sync Gateway to prevent any new writes from coming in.
1. Wait until the target Couchbase Server has caught up to all the writes in the source Couchbase Server cluster -- this should happen very quickly, since it will only be the residual writes in transit before the Sync Gateway shutdown.
1. Restart Sync Gateway, configured to run against the target Couchbase Server.

**Caveat: small amount of downtime during switchover**

Since there may be writes still in transit after Sync Gateway has been shutdown, there will need to be some downtime until the target Couchbase Server cluster is completely caught up.

**Caveat: increased risk due to XDCR errors**

Since XDCR is a more complicated process than a simple backup/restore operation, there is increased risk of data not being replicated to the target cluster.  This can be mitigated by a thorough comparison between the source and target cluster before bringing Sync Gateway back online.


## Online Upgrade

1. Do an [Online Upgrade](https://developer.couchbase.com/documentation/server/4.1/install/upgrade-online.html) of Couchbase Server and wait until completion
1. Do a rolling restart of the Sync Gateway nodes

The rolling restart of the Sync Gateway nodes is needed because there is a chance the Sync Gateway nodes could lose the mutation feed (TAP or DCP) along the way.

**Caveat: risk of transient connection errors**

The Couchbase Server rebalance operations can result in an increase of risk of transient connection errors between Couchbase Server and Sync Gateway, which could result in Sync Gateway performance degradation.

**Caveat: increased risk of unexpected server errors during rebalance, which can lead to data loss**

While there is always the potential for server failovers and rollbacks to occur, which will lead to a small amount of data loss due to the rollbacks, this risk is slightly increased during rebalance operations.







