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