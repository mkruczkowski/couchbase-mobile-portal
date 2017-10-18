---
id: tutorial-overview
title: Tutorial Overview
permalink: training/index.html
---

Couchbase Mobile brings the power of NoSQL to mobile. It is comprised of three different components: Couchbase Lite, an embedded NoSQL database, Sync Gateway, an internet-facing synchronization mechanism that securely syncs data between device and cloud, and Couchbase Server, a highly scalable and performant NoSQL database in the cloud. 

Couchbase Mobile simplifies "offline first" development. As shown on the diagram below, Couchbase Lite runs locally on the device and persists data as JSON and binary format. You can perform CRUD operations directly to the local database.

![](img/image57.png)

Sync Gateway is the web tier that exposes a database API for Couchbase Lite databases to replicate to and from  Couchbase Server (data is not persisted in Sync Gateway). Couchbase Server is used as a storage engine by Sync Gateway.

In this developer tutorial series, you will build a ToDo List application with Couchbase Mobile and learn how to use the database, add synchronization, and add security.

<block class="ios" />

<img src="./img/image11.png" class="portrait" />

<block class="wpf" />

<img src="./img/image11w.png" class="center-image" />

<block class="xam" />

**iOS**
<img src="./img/image11.png" class="portrait" />
**Android**
<img src="./img/image11xa.png" class="portrait" />

<block class="android" />

<img src="img/image11a.png" class="portrait" />

<block class="all" />

## Course Outline

### Data Modeling

How to choose the data structure for entities and relationships between those entities.

- Documents types
- Relationships between Documents

### Design

How to convert a set of application requirements and business rules into security rules for Couchbase Mobile.

- Access to Channels
- User privileges

### Using the Database

How to use the persistence APIs and query language for simple queries and data aggregation to perform query operations across different model types.

- Querying Data
- Writing Data
- Aggregating Data

### Adding Synchronization

How to install Sync Gateway on your development environment, start the synchronization from the application and manage conflicts.

- Installation
- Synchronizing
- Detecting and resolving Conflicts

### Adding Security

How to add access control rules based on each authenticated user and how to add  security locally with database encryption and offline login.

- User Authentication
- Read/Write Access Controls
- Database Encryption
- Offline Login