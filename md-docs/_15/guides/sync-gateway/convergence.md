---
title: Convergence
permalink: guides/sync-gateway/index.html
---

<!--

Plan:

- [x] [GA] Update configuration file [reference](https://developer.couchbase.com/documentation/mobile/current/guides/sync-gateway/config-properties/index.html) (Adam)
	- The backing yaml file must be updated here on the [convergence](https://github.com/couchbaselabs/couchbase-mobile-portal/blob/convergence/configs/20/sg.yaml) branch.

- [x] Provide example config for most common scenario (Adam, *included below*)
	- Can be inserted on the stub [convergence.md](https://github.com/couchbaselabs/couchbase-mobile-portal/blob/convergence/md-docs/_20/guides/sync-gateway/convergence.md) file.
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
- [ ] Release notes for convergence.
	- Improve the process to edit/review release notes. Scope already covered in [#596](https://github.com/couchbaselabs/couchbase-mobile-portal/issues/596) (James)
	Edit the release notes once the process is improved (Adam)

-->

## Overview

With Sync Gateway 1.5 and Couchbase Server 5.0, sharing data between mobile and server applications is easier than ever.  Both mobile and server applications can now read and write data in the same bucket. 

### Extended Attributes

Previously, mobile metadata was stored along with the document body (as a `_sync` property). Updates made anywhere other than Sync Gateway would invalidate or overwrite that data, breaking mobile replication.  In Sync Gateway 1.5, the mobile metadata is moved out of the document body and into a system extended attribute, only accessible by Sync Gateway.  

### Import

In order for non-Sync Gateway updates to be available to mobile clients, they need to be imported by Sync Gateway.  The import process applies both security (by executing the Sync Function), as well as updating the document's sequence and revision history.


### Sync Function

When a non-Sync Gateway write is imported into Sync Gateway, that import is done as with admin credentials.  This means that any write security (`requireUser`, `requireRole`, `requireChannel`) in the Sync Function is bypassed during import.  For non-Sync Gateway writes, it's assumed that the application making those writes is applying the appropriate write security.  When executing the Sync Function for an import, oldDoc is empty.

Channel assignment and access grants performed by the Sync Function behave as usual during import.  

## Try it out

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
				"import_docs": continuous
			}
		}
	}
	```

6. On start-up, Sync Gateway will generate the mobile-specific metadata for all the pre-existing documents in the Couchbase Server bucket.  From then on, documents can be inserted on the Server directly (SDKs) or through the Sync Gateway REST API.
