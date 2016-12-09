---
id: faq
title: FAQ
permalink: ready/guides/faq/index.html
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