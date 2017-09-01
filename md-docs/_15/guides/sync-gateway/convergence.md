---
title: Convergence
permalink: whatsnew.html
---

{% include landing.html %}

<!--

Plan:

- [x] [GA] Update configuration file [reference](https://developer.couchbase.com/documentation/mobile/current/guides/sync-gateway/config-properties/index.html) (Adam)
	- The backing yaml file must be updated here on the [convergence](https://github.com/couchbaselabs/couchbase-mobile-portal/blob/convergence/configs/20/sg.yaml) branch.

- [x] Provide example config for most common scenario (Adam, *included below*)
	- Can be inserted on the stub [convergence.md](https://github.com/couchbaselabs/couchbase-mobile-portal/blob/convergence/md-docs/_20/guides/sync-gateway/convergence.md) file.
- [ ] [DP2/GA] Compatibility matrix
	- 1.5 will enable convergence if the server is =< 5.0, otherwise will not enable it.
- [ ] [DP2/GA] Conceptual explanation of a server-only application that starts using mobile
	- Provide what is expected from an end user point of view (Sachin)
		1. Pre-deployment planning
			- User creation for mobile users – why? How are these different from server users?
			- Choose an authentication option from the ones available – link to the different portions of the SG guide
			- Choose which documents/buckets would be enabled for convergence (auto-import)
		2. Deployment
			- Create a SG cluster
			- Configuration of SG
			- Configure docs/buckets for mobile enablement/auto-import
		3. Add CBL to mobile application
			- Link to getting started guides on dev portal
	- Provide implementation notes and details (Adam) 
- [ ] [DP2/GA] Conceptual explanation of a mobile-only application that starts using server SDKs.
	- Provide what is expected from an end user point of view (Sachin)
		1. Pre-deployment planning
			- Choose the application development strategy for the server application developed using one of our SDKs.
			- Choose which documents/buckets would be enabled for convergence (auto-import)
		2. Deployment
			- Upgrade CB server cluster to Spock and SG to 2.1
			- Configuration of SG
			- Configure docs/buckets for mobile enablement/auto-import
		3. Impact on mobile app
			- No impact. Call out the compatibility between SG 2.x and CBL 1.x
	- Provide implementation notes and details (Adam)
- [ ] [DP2/GA] Migrating from bucket shadowing.
	- Remove bucket shadowing docs from 1.5 (in 1.4 only)
	- Explain strategy on migrating from bucket shadowing to 1.5
- [ ] [DP2/GA] Release notes for convergence.
	- Improve the process to edit/review release notes. Scope already covered in [#596](https://github.com/couchbaselabs/couchbase-mobile-portal/issues/596) (James)
	Edit the release notes once the process is improved (Adam)

-->

## Overview

With Sync Gateway 1.5 and Couchbase Server 5.0, sharing data between mobile and server applications is easier than ever. Both mobile and server applications can now read and write data in the same bucket.

## Compatibility

#### Sync Gateway - Couchbase Server

The table below shows the versions of Sync Gateway compatible with Couchbase Server.

|CB Server/Sync Gateway|SG 1.5|SG 1.5 (XATTRs)|
|:--------------|:------|:-----|
|CB 4.0|✔|✖|
|CB 4.1|✔|✖|
|CB 4.5|✔|✖|
|CB 4.6|✔|✖|
|CB 5.0|✔|✔|

For all of the above, the [bucket type](https://developer.couchbase.com/documentation/server/5.0/architecture/core-data-access-buckets.html#concept_qqk_4r2_xs) must be Couchbase. Usage of Ephemeral and Memcached buckets with Couchbase Mobile is not supported.

#### Couchbase Lite - Sync Gateway

|CB Lite/Sync Gateway|SG 1.5|SG 1.5 (XATTRs)|
|:--------------|:------|:-----|
|CBL 1.3|✔|✔|
|CBL 1.4|✔|✔|
|CBL 2.0|✔|✔|

### Extended Attributes

Previously, mobile metadata was stored along with the document body (as a `_sync` property). Updates made anywhere other than Sync Gateway would invalidate or overwrite that data, breaking mobile replication.  In Sync Gateway 1.5, the mobile metadata is moved out of the document body and into a system extended attribute, only accessible by Sync Gateway.  

### Import

In order for non-Sync Gateway updates to be available to mobile clients, they need to be imported by Sync Gateway.  The import process applies both security (by executing the Sync Function), as well as updating the document's sequence and revision history.


### Sync Function

When a non-Sync Gateway write is imported into Sync Gateway, that import is done as with admin credentials.  This means that any write security (`requireUser`, `requireRole`, `requireChannel`) in the Sync Function is bypassed during import.  For non-Sync Gateway writes, it's assumed that the application making those writes is applying the appropriate write security.  When executing the Sync Function for an import, oldDoc is empty.

Channel assignment and access grants performed by the Sync Function behave as usual during import.  

### Users

The method of [authorizing users](https://developer.couchbase.com/documentation/mobile/current/guides/sync-gateway/authorizing-users/index.html) in Sync Gateway 1.5 is unchanged. As with previous versions, the security rules are defined in the Sync Function. A user is defined with a **name** and **password** in Sync Gateway which Couchbase Lite clients use in replications. However, SDK operations to the same bucket cannot be user authenticated.

For example, let's consider a server application that is using Couchbase SDKs to support a web client. Users may want to access the same data on the web as they would on mobile devices. In this case, the server application must verify the user credentials sent from the web client against the Sync Gateway [/{db}/_session](https://developer.couchbase.com/documentation/mobile/current/references/sync-gateway/rest-api/index.html#!/session/post_db_session) endpoint first before allowing any read/write operation to the bucket.

### Metadata Purge Interval

Starting in 1.5, tombstones will be purged based on Couchbase Server's Metadata Purge Interval. The default Metadata Purge Interval is set to 3 days which can potentially result in tombstones being purged before all clients have had to chance to get notified of it. For that reason, the Metadata Purge Interval should be increased to the maximum amount of time users are expected to be offline between pull replications.

Ways to tune the Metadata Purge Interval:

- Bucket settings [on UI](https://developer.couchbase.com/documentation/server/5.0/settings/configure-compact-settings.html)
- Bucket endpoint [on the REST API](https://developer.couchbase.com/documentation/server/4.6/rest-api/rest-bucket-create.html)

## Sample App

The following tutorial demonstrates the extended attributes support introduced in Sync Gateway 1.5.

<div class="dp">
	<div class="tiles">
		<div class="column size-1of2">
			<div class="box">
				<div class="container">
					<a href="http://docs.couchbase.com/tutorials/travel-sample-mobile.html" taget="_blank">
						<p style="text-align: center;">Travel Sample Mobile</p>
					</a>
				</div>
			</div>
		</div>
	</div>
</div>
<br/>
<br/>

## Getting Started

1. [Download the latest Developer Build](https://www.couchbase.com/downloads) of Couchbase Server 5.0.
2. [Download Sync Gateway](https://www.couchbase.com/downloads?family=Mobile&product=Couchbase%20Sync%20Gateway&edition=Enterprise%20Edition 
).
3. Create a new bucket in the Couchbase Server Admin Console.
4. Create a Couchbase Server user for Sync Gateway to use (Security/Add User in the Couchbase Server Admin Console), and grant that user the 'Bucket Full Access' role for your new bucket from step 3.
5. Start Sync Gateway with the following configuration file.

	```json
	{
		"databases": {
			"db": {
				"bucket": "my-bucket",
				"username": "my-user",
				"password": "my-password",
				"server": "http://localhost:8091",
				"unsupported": {
					"enable_extended_attributes": true
				},
				"import_docs": "continuous"
			}
		}
	}
	```

6. On start-up, Sync Gateway will generate the mobile-specific metadata for all the pre-existing documents in the Couchbase Server bucket.  From then on, documents can be inserted on the Server directly (SDKs) or through the Sync Gateway REST API.

## Upgrading

To upgrade Sync Gateway to 1.5, you will need to stop all Sync Gateway instances. This means that mobile applications will not be able to push or pull data to the server during that time. Run the following steps to upgrade an existing deployment.

1. Follow the recommendations in the [Couchbase Server documentation](https://developer.couchbase.com/documentation/server/current/install/upgrade-online.html) to upgrade all instances to 5.0. Note that Sync Gateway 1.4 instances can run with a Couchbase Server cluster that has been upgraded to use 5.0.
2. Stop all Sync Gateway instances.
3. If you wish to use Sync Gateway 1.5 with the convergence feature, update the configuration file as shown above.
4. Start Sync Gateway instances. Note that starting Sync Gateway 1.5 instances with convergence enabled in the configuration file will trigger all existing documents to be re-processed. So it may take a while before Sync Gateway appears online. You may monitor the logs to track the progress of this operation.
5. Replications with clients (i.e Couchbase Lite) should now resume.

> **Note:** Enabling convergence on your existing deployment (i.e XATTRs) is **not** reversible. It is recommended to test the upgrade on a staging environment before upgrading the production environment.

## Migrating from Bucket Shadowing

As of Sync Gateway 1.5, the Bucket Shadowing feature is deprecated and no longer supported. The following steps outline a recommended method for migrating from Bucket Shadowing to the latest version with interoperability between Couchbase Server SDKs and Couchbase Mobile.

1. Follow the recommendations in the [Couchbase Server documentation](https://developer.couchbase.com/documentation/server/current/install/upgrade-online.html) to upgrade all instances to 5.0.
2. Update Couchbase Server SDK applications to read/write documents to the mobile bucket.
3. Make sure that all documents are present in the mobile bucket, the Sync Function may have rejected some documents based on the access control rules for example. If you are not using a Sync Function you can ignore this verification step.
4. Delete the shadow bucket from Couchbase Server.
5. Perform an upgrade of Sync Gateway instances as [detailed above](whatsnew.html#upgrading). This upgrade will incur some application downtime.
6. Monitor the Sync Gateway logs upon start-up.
7. Replications with mobile clients (i.e Couchbase Lite) should now resume.
