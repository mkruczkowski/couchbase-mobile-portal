---
id: how-to-google
title: How-To Google
permalink: guides/authentication/openid/google/index.html
---

In this guide, we will use Google with Auth Code Flow as an example for the OpenID Provider (abbreviated OP) but similar steps apply for any other OP that you intend to use.

## Creating a Google project

Follow the instructions below to create a new project in the Google API manager:

1. Go to the [API Manager](https://console.developers.google.com/iam-admin/projects).
2. Select the **Create a project...** menu.
	![](../img/api-manager-create-project.png)
3. Provide a name for your project.
4. Enable the **OAuth consent screen**.
	![](../img/consent-screen.png)
5. Create a new **OAuth client ID** from the **Credentials** menu.
	![](../img/oauth-client-id.png)
6. On the next page, select **Web application** to enable the authorization code flow.  Select **iOS** or **Android** to enable the implicit flow (Google Sign-In) and specify the origin and callback URLs for your Sync Gateway: 
  - `http://localhost:4984` is the origin of your Sync Gateway instance.
  - `http://localhost:4984/dbname/_oidc_callback` is the callback URL endpoint for your database.
	![](../img/create-credential.png)
7. Click **Create** and note the generated client id and client secret - they need to be included in your Sync Gateway config.

## Setting Up Sync Gateway

With the Google API project you created in the previous section you can now configure Sync Gateway. Create a new file called `sync-gateway-config.json` with the following:

```javascript
{
  "log":["*"],
  "databases": {
    "untitledapp": {
      "server": "walrus:",
      "oidc": {
        "providers": {
          "GoogleAuthFlow": {
            "issuer": "https://accounts.google.com",
            "client_id": "912925907766-t25....",
            "validation_key": "your_client_secret",
            "callback_url": "http://localhost:4984/untitledapp/_oidc_callback",
            "register": true
          }
        }
      },
      "sync": `
        function(doc, oldDoc) {
          var username = doc.owner;
          if (!username)
            throw({forbidden : "item must have an owner"})
          
          var channelName = "ch-" + username;
          access (username, channelName)
          channel(channelName);
        }
      `
    }
  }
}
```

[Download Sync Gateway](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile) and start it from the command line with this configuration file:

```bash
~/Downloads/couchbase-sync-gateway/bin/sync_gateway sync-gateway-config.json
```

To test that everything is setup correctly open a web browser at [http://localhost:4984/untitledapp/_oidc](http://localhost:4984/untitledapp/_oidc). You are then redirected to login and to the consent screen.

![](../img/consent-screen-testing.png)

The browser is then redirected to [http://localhost:4984/untitledapp/\_oidc_callback](http://localhost:4984/untitledapp/_oidc_callback) with additional parameters in the querystring, and Sync Gateway returns the response:

```javascript
{
	"id_token":"eyJhbG....Rjq1DFipw",
	"session_id":"c518975db2ad094548188a232a875ea547bce966",
	"name":"accounts.google.com_108110999398334894801"
}
```

You can then verify the validity of the `session_id` by setting it in the request header. Using curl, that would be the following.

```bash
curl -vX GET -H 'Content-Type: application/json' \
             --cookie 'SyncGatewaySession=c518975db2ad094548188a232a875ea547bce966' \
             'http://localhost:4984/untitledapp/'
```

## Setting Up Couchbase Lite

With Sync Gateway up and running you can now use the Couchbase Lite Authenticator class. To save time, you will clone and run a sample app called **Grocery Sync** where OpenID Connect with Google is already implemented.

### iOS

The [openid branch of Grocery Sync iOS](https://github.com/couchbaselabs/Grocery-Sync-iOS/tree/openid) is a working sample that demonstrates how to use OpenID Connect with the Couchbase Lite iOS SDK and Sync Gateway.

1. Clone the repository: `git clone https://github.com/couchbaselabs/Grocery-Sync-iOS.git`
2. Checkout on the `openid` branch `git checkout origin/openid`
3. [Download Sync Gateway](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile)
4. Start Sync Gateway with the config file you created in the previous step: `~/path/to/sync_gateway sync-gateway-config.json`
5. In `AppDelegate.m`, replace the `kServerDbURL` with the URL of your Sync Gateway instance `http://localhost:4984/untitledapp`

You can login with your Google+ account using the Auth Code Flow.

![](../img/images.001.png)

Then, open the `Users` tab of the Admin UI at [http://localhost:4985/_admin/db/untitledapp/users](http://localhost:4985/_admin/db/untitledapp/users). Notice a new user is registed:

![](../img/user-auth-code-flow.png)

### Android

The [feature/openid branch of Grocery Sync Android](https://github.com/couchbaselabs/GrocerySync-Android/tree/feature/openid) is a working sample that demonstrates how to use OpenID Connect with the Couchbase Lite Android SDK and Sync Gateway.

1. Clone the repository: `git clone https://github.com/couchbaselabs/GrocerySync-Android.git`
2. Checkout on the `feature/openid` branch `git checkout origin/feature/openid`
3. [Download Sync Gateway](http://www.couchbase.com/nosql-databases/downloads#couchbase-mobile)
4. Start Sync Gateway with the config file you created in the previous step: `~/path/to/sync_gateway sync-gateway-config.json`
5. In `Application.java`, replace the `SERVER_DB_URL` with the URL of your Sync Gateway instance `http://10.0.2.2:4984/untitledapp` (or `10.0.3.2` if you're running an Genymotion emulator).

You can login with your Google+ account using the Auth Code Flow.

![](../img/images.004.png)

Then, open the `Users` tab of the Admin UI at [http://localhost:4985/_admin/db/untitledapp/users](http://localhost:4985/_admin/db/untitledapp/users).. Notice a new user is registered:

![](../img/user-auth-code-flow.png)

> If you ran the app on both platforms and logged in with the same Google account then list items should sync across devices/emulators. 

![](../img/sync-platforms.png)