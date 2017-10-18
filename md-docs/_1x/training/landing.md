1. Design

Before you start coding, it's important to lay down all the business rules for the application. This section will introduce the application's data models and security rules.

- Data Modeling: How to choose the data structure for entities and relationships between those entities.

- Security: How to convert a set of application requirements and business rules into security rules for Couchbase Mobile.

2. Develop

The first steps to getting your project off the ground with Couchbase Mobile is to use local persistence with Couchbase Lite. Once your app is built to save data locally it's very easy to plug in the server-side component, Sync Gateway.

- Create, Read, Update, Delete, Query: How to use the persistence APIs and query language for simple queries and data aggregation to perform query operations across different model types.

- Synchronization: How to install Sync Gateway on your development environment, start the synchronization from the application and manage conflicts.

- Security: How to add access control rules based on each authenticated user and how to add security locally with database encryption and offline login.

- Integration: How to use webhooks to trigger events on external systems and use the Sync Gateway REST API to import data in Couchbase Mobile.

3. Test

Before releasing your application you must ensure that the requirements set out in the first section of the training are met. This section covers best practices to test the functional and scalability aspects of the application.

- Functional: How to test the security model of the application and make changes to the data model and sync function in the final stages of your release cycle.

- Scalability & Performance: How to identify the test scenarios that are crucial to your application and implement them with load testing tools.

4. Deploy

Deploying to the app stores and to the cloud at once can be challenging. This section will walk you through this process.

- Deploy: How to setup cloud deployment for a staging and production environment and how to continuously deploy to the staging servers.

- Upgrade: How to perform a database upgrade or schema migration of an application that already went live.

- Scale: How to identify perfomance bottlenecks or a steep increase in the load and responding to it by using several Sync Gateway instances behind a load balancer.