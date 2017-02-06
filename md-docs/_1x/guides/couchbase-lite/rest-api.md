---
title: REST API
---

An introductory guide to the Couchbase Lite APIs. The Couchbase Lite Listener exposes the same functionality as the native SDKs through a common RESTful API. You can perform the same operations on the database by making API calles.

The Listener API handles data as JSON documents, and uses the same concepts such as revisions, documents, replications, views and queries.

## View query

The code below shows you how to:

- Create a database.
- Register a view with the database.
- Add documents.
- Query the view.

{% include java-codepen.html %}

<p data-height="300" data-theme-id="27686" data-slug-hash="zNLqyL" data-default-tab="js,result" data-user="Jamiltz" data-embed-version="2" data-pen-title="Get docs by keys" class="codepen">See the Pen <a href="http://codepen.io/Jamiltz/pen/zNLqyL/">Get docs by keys</a> by Jamiltz (<a href="http://codepen.io/Jamiltz">@Jamiltz</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>