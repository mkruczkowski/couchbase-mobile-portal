---
id: guides
title: Guides
permalink: guides/index.html
---

### Couchbase Lite

Couchbase Lite is an embedded JSON database that can work standalone, in a P2P network, or as a remote endpoint for Sync Gateway.

Couchbase Lite:

- Represents data with a flexible schema form, JSON. This means that you don't have to define a rigid data layout beforehand, and later go through complex migrations if you need to update it.
- Provides Native APIs for iOS, Android and .NET. With the Native APIs, you can map database documents to your own native object model, work directly with JSON structures, or both. Additionally, apps built with web technologies, such as JavaScript, can use the Couchbase Lite REST APIs to develop hybrid mobile apps.
- Supports replication with compatible database servers. This gives your app best-of-breed sync capabilities. Not only can the user's data stay in sync across multiple devices, but multiple users' data can be synced together.
- Supports peer-to-peer replication. By adding an extra HTTP listener component, your app can accept connections from other devices running Couchbase Lite and exchange data with them.
- Supports low-latency and offline access to data, you work primarily with local data. This means your app remains responsive whether it's on Wi-Fi, a slow cell network, or offline. The user can even modify data while offline, and it'll be synced to the server as soon as possible.

### Sync Gateway

Sync Gateway:

- Maintains up-to-date copies of documents where users need them. On mobile devices for instant access and on servers in data centers for reasons such as synchronizing documents, sharing documents, and loss-protection. Mobile apps create, update, and delete files locally, Sync Gateway takes care of the rest.
- Provides access control, ensuring that users can only access documents to which they should have access.
- Ensures that only _relevant_ documents are synced. Sync Gateway accomplishes this by examining document and applying business logic to decide whether to assign the documents to channels. Access control and ensuring that only relevant documents are synced are achieved through the use of _channels_ and the _sync function_.