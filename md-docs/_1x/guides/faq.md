---
id: faq
title: FAQ
---

### Accessing attachments through the REST API

Attachmnents can be accessed through the REST API using the `/{db}/{id}/{name}` endpoint. If the attachment is an image, video or audio track and you wish to load it in a WebView, the recommended approach is to use the web semantics to load it on the view.

```html
// user, password, host, port, db: parameters that should be retrieved through your application lifecycle methods when initializing Couchbase Lite.
// id, name: specifies the attachment name to retrieve from the document with that id.

<img="http://${user}:${password}@${host}:${port}/${id}/${name}" />
```

### How do I access documents in a channel from the Sync Gateway API?

If you know the set of channels, you can issue a one-shot changes request with a channels filter to get the set of documents in those channels.

If you don't know the channels (and just want to get all documents available for a given user), you can issue a one-shot changes request as the given user - either using basic auth to authenticate the request as the user, or by first creating a session for the user via the admin REST API and using the session token to authenticate.

### Documents are not being pulled from Sync Gateway

1. Verify that the Sync Gateway URL in your app is set correctly and that it is accessible from the browser on the device/emulator.
2. What is the access control for those documents?

    - Without user authentication, you must ensure that the `GUEST` user is enabled in the Sync Gateway configuration file:

      ```javascript
      {
        "log": ["*"],
        "databases": {
          "db": {
            "server": "http://localhost:8091",
            "bucket": "default",
            "users": { "GUEST": { "disabled": false, "admin_channels": ["*"] } }
          }
        }
      }
      ```

    - With user authentication, you can verify that the user has access to those documents by issuing a GET `http://{user}:{password}@localhost:4984/{db}/_changes?include_docs=true` and checking if they are present in the response.

### Can I specify the order in which documents get replicated?

As a distributed system, Couchbase Mobile can't preserve ordering of updates, nor can it provide transactions.

A common scenario where this has to be handled specifically is when a document (doc A) references another one (doc B). If you're writing reactive code that updates the UI (or other dependent state) as documents change, then your app will be eventually-consistent. In the case you describe, if a leaf document hasn't been pulled yet, your code will see an empty document at first; then when the leaf arrives, you'll update it with the pulled revision and display the correct data.

### How can I remove revisions to free up space on the server?

The right API to use depends on what you wish to achieve. The table below outlines the different APIs depending on the goal.

|Motivation|Sync Gateway API|Couchbase Lite API|
|:--|:--|:--|
|Configure the length of the revision tree for all documents.|`revs_limit`|`database.maxRevTreeDepth`|
|Remove a single document from a database based on abitrary logic.|`/{db}/_purge`|`database.purgeDocument`|
|Remove a single document after a certain amount of time.|`/{db}/{id}`|`document.setExpirationDate`|

### Paginating content from Sync Gateway

<img src="img/pagination.png" width="25%" />

Paginating a list view is a good pattern when the data source is fairly large and is retrieved over the Sync Gateway REST API. If you wish to display the documents in a channel for example, it's recommended to use the `/{db}/_changes` endpoint with the `limit` and `since` querystring parameters. If you wish to display the documents in a logical order by key then you can use the `/{db}/_all_docs` endpoint with the `startkey` and `limit` querystring parameters.
