
# Upgrading a Couchbase Server cluster used by Sync Gateway

There are several overall approaches to upgrading the Couchbase Server cluster that is used by Sync Gateway:

| Upgrade Strategy  | Downtime | Additional Machine Requirements 
| ------------- | ------------- | ------------- |
| Rolling Online Upgrade  | None  | Low |
| Upgrade Using Inter-cluster Replication  | Small amount during switchover  | High - duplicate entire cluster |
| Offline Upgrade  | During entire upgrade  | None  |

## Rolling Online Upgrade

1. Do an [Online Upgrade](https://developer.couchbase.com/documentation/server/current/install/upgrade-online.html) of Couchbase Server and wait until completion
1. Do a rolling restart of the Sync Gateway nodes

The rolling restart of the Sync Gateway nodes is needed because there is a chance the Sync Gateway nodes could lose the mutation feed (TAP or DCP) along the way.

**Caveat: potential transient connection errors**

The Couchbase Server rebalance operations can result in transient connection errors between Couchbase Server and Sync Gateway, which could result in Sync Gateway performance degradation.

**Caveat: potential for unexpected server errors during rebalance**

There is an increased potential to lose in-flight ops during a failover.

## Upgrade Using Inter-cluster Replication

Using an XDCR (Cross Data Center Replication) approach will have incur some Sync Gateway downtime, but less downtime than other approaches where Sync Gateway is shutdown during the entire Couchbase Server upgrade.

It's important to note that the XDCR replication must be a **one way** replication from the existing (source) Couchbase Server cluster to the new (target) Couchbase Server cluster, and that no other writes can happen on the new (target) Couchbase Server cluster other than the writes from the XDCR replication, and no Sync Gateway instances should be configured to use the new (target) Couchbase Server cluster until the last step in the process.

1. Start XDCR to do a one way replication from the existing (source) Couchbase Server cluster to the new (target) Couchbase Server cluster running the newer version.
1. Wait until the target Couchbase Server has caught up to all the writes in the source Couchbase Server cluster.
1. Shutdown Sync Gateway to prevent any new writes from coming in.
1. Wait until the target Couchbase Server has caught up to all the writes in the source Couchbase Server cluster -- this should happen very quickly, since it will only be the residual writes in transit before the Sync Gateway shutdown.
1. Reconfigure Sync Gateway to point to the target cluster.
1. Restart Sync Gateway.

**Caveat: small amount of downtime during switchover**

Since there may be writes still in transit after Sync Gateway has been shutdown, there will need to be some downtime until the target Couchbase Server cluster is completely caught up.

**Caveat: XDCR should be monitored **

Make sure to monitor the XDCR relationship as per [XDCR docs](https://developer.couchbase.com/documentation/server/current/xdcr/xdcr-intro.html) 

## Offline Upgrade

1. Take Sync Gateway offline
1. Upgrade Couchbase Server using any of the options mentioned in the [Upgrading Couchbase Server](https://developer.couchbase.com/documentation/server/current/install/upgrading.html) documentation.  
1. Bring Sync Gateway online






