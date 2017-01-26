---
id: nginx
title: NGINX
permalink: guides/sync-gateway/nginx/index.html
---

In this guide we'll show how to deploy Sync Gateway with nginx acting as a reverse proxy.

## When to use a reverse proxy

- A reverse proxy can hide the existence of a Sync Gateway server or servers. This can help to secure the Sync gateway instances when your service is exposed to the internet.
- A reverse proxy can provide application firewall features that protect against common web-based attacks.
- A reverse proxy can offload ssl termination from the Sync Gateway instances, this can be a significant overhead when supporting large numbers of mobile devices.
- A reverse proxy can distribute the load from incoming requests to several Sync Gateway instances.
- A reverse proxy may rewrite the URL of each incoming request in order to match the relevant internal location of the requested resource. For Sync Gateway the reverse proxy may map the Internet facing port 80 to the standard Sync Gateway public REST API port 4984.

## Installing NGINX

Connect to the server running Sync Gateway and install the nginx server:

```bash
sudo apt-get install nginx
```

This will install and start the nginx server. You can validate this by viewing the following web page in your browser:

```bash
http://127.0.0.1/
```

Note: Replace 127.0.0.1 with the IP address of your server.

You should see the standard Welcome to nginx! page.

## Basic nginx configuration for Sync Gateway

If you installed nginx using the instructions above, then you will create your sync\_gateway configuration file in **/etc/nginx/sites-available**. Create a file in that directory called sync\_gateway with the following content:

```groovy
upstream sync_gateway {
    server 127.0.0.1:4984;
}
# HTTP server
#
server {
    listen 80;
    server_name  myservice.example.org;
    client_max_body_size 20m;
    location / {
        proxy_pass              http://sync_gateway;
        proxy_pass_header       Accept;
        proxy_pass_header       Server;
        proxy_http_version      1.1;
        keepalive_requests      1000;
        keepalive_timeout       360s;
        proxy_read_timeout      360s;
    }
}
```

This `upstream` block specifies the server and port nginx will forward traffic to, in this example it would be sync\_gateway running on the same server as nginx, listening on the default public REST API port of 4984. Change these values if your sync\_gateway is
 configured differently.

```groovy
# HTTP server
#
server {
    listen 80;
    server_name  myservice.example.org;
    client_max_body_size 21m;
```

The first section of the 'server' block defines common directives.

- The 'listen' directive instructs nginx to listen on port 80 for incoming traffic.
- The server\_name directive instructs nginx to check that the HTTP 'Host:' header value matches 'myservice.example.org' (change this value to your domain).
- The 'client\_max\_body\_size' directive instructs nginx to accept request bodies up to 21MBytes, this is necessary to support attachments being sync'd to Sync Gateway.

```groovy
location / {
    proxy_pass              http://sync_gateway;
    proxy_pass_header       Accept;
    proxy_pass_header       Server;
    proxy_http_version      1.1;
    keepalive_requests      1000;
    keepalive_timeout       360s;
    proxy_read_timeout      360s;
}
```

The location block specifies directives for all URL paths below the root path '/'.

- The 'proxy\_pass' directive instructs nginx to forward all incoming traffic to servers defined in the sync_gateway 
upstream block.
- The two 'proxy\_pass\_header' directives instruct nginx to pass 'Accept:' and 'Server:' headers on inbound and 
outbound traffic, these headers allow CouchbaseLite and sync_gateway to optimise data transfer, e.g. by using gzip compression and multipart/mixed if it is supported.
- The 'keepalive\_requests' directive instructs nginx to allow up to one thousand requests on the same connection, this is useful when getting a _changes feed using longpoll.
- The 'keepalive\_timeout' directive instructs nginx to keep connection open for 360 seconds from the last request, this value is longer than the default (300 seconds) value for the heartbeat on the _changes feed using longpoll.
- The 'proxy\_read\_timeout' directive instructs nginx to keep connection open for 360 seconds from the last server response, this value is longer than the default (300 seconds) value for the heartbeat on the _changes feed using longpoll.

We now need to enable the sync\_gateway site, in the sites-enabled directory you need to make a symbolic link to the 
sync\_gateway file you just created:

```bash
ln -s /etc/nginx/sites-available/sync_gateway /etc/nginx/sites-enabled/sync_gateway
```

and then restart nginx:

```bash
sudo service nginx restart
```

Either take a look at the site in your web browser, or use a command line option like curl or wget, specifying the virtual host name you created above, and you should see that you are request is proxied through to the Sync Gateway, but your traffic is going over port 80:

```bash
curl http://myservice.example.org/
{“couchdb”:”Welcome”,”vendor”:{“name”:”Couchbase Sync Gateway”,”version”:1},”version”:”Couchbase Sync Gateway/1.0.3(81;fa9a6e7)”}
```

If you access your server using its IP address (so that no Host name is passed).

```bash
http://127.0.0.1/
```

Note: Replace 127.0.0.1 with the IP address of your server.

You should see the standard Welcome to nginx! page.

## Adding websocket support

Couhbase Lite introduces websocket support for the changes feed, but by default nginx will not upgrade it's connection to Sync Gateway to support websockets. If an iOS client has websockets enabled for the _changes feed it will be unable to to pull replicate from a Sync Gateway behind an nginx reverse proxy. To enable websockets support, update the location block by adding the following two directives.

```groovy
location / {
    .
    .  
    proxy_set_header        Upgrade $http_upgrade;
    proxy_set_header        Connection "upgrade";
    .
    .
}
```

## Load balancing requests

Sync gateway instances have a 'shared nothing' architecture, this means that you can scale out by simply deploying additional Sync Gateway instances. But incoming traffic needs to be distributed across all the instances, ngingx can easily accommodate this and balance the incoming traffic load across all your Sync Gateway instances. Simply add the additional instances to the 'upstream' block as shown below.

```bash
upstream sync_gateway {
    server 192.168.1.10:4984;
    server 192.168.1.11:4984;
    server 192.168.1.12:4984;
}
```

## Transport Layer Security (HTTPS)

To secure data between clients and Sync Gateway in production, you will want to use secure HTTPS connections.

For production you should get a cert from a reputable Certificate Authority, which will be signed by that authority. For testing you can create your own self-signed certificate, it's pretty easy using the openssl command-line tool and these directions, you just need to run these commands:

First create the directory where the certificate and key will be created

```bash
sudo mkdir -p /etc/nginx/ssl
```

```bash
sudo openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```

The command is interactive and will ask you for information like country and city name that goes into the X.509 certificate. You can put whatever you want there; the only important part is the field Common Name (e.g. server FQDN or YOUR name) which needs to be the exact hostname that clients will reach your server at. The client will verify that this name matches the hostname in the URL it's trying to access, and will reject the connection if it doesn't.

You should now have two files, a certificate in /etc/nginx/ssl/nginx.crt and a key in /etc/nginx/ssl/nginx.key.

We will add a new server section to the sync_gateway nginx configuration file to support SSL termination.

```groovy
server {
    listen 443 ssl;
    server_name  myservice.example.org;
    client_max_body_size 21m;                            
    ssl on;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_protocols TLSv1;
    location / {
        proxy_pass              http://sync_gateway;
        proxy_pass_header       Accept;
        proxy_pass_header       Server;
        proxy_http_version      1.1;
        keepalive_requests      1000;
        keepalive_timeout       360s;
        proxy_read_timeout      360s;
    }
}
```

Restart nginx to enable the new server:

```bash
sudo service nginx restart
```

Test using curl:

```bash
curl -k https://myservice.example.org/
{“couchdb”:”Welcome”,”vendor”:{“name”:”Couchbase Sync Gateway”,”version”:1},”version”:”Couchbase Sync Gateway/1.0.3(81;fa9a6e7)”}
```

You can also see this by going to https://myservice.example.org/ in your browser.