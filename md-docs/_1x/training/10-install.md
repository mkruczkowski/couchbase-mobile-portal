---
id: install
title: Install
permalink: training/deploy/install/index.html
---

In this lesson you'll learn how to install Sync Gateway and Couchbase Server, our NoSQL database server.

[//]: # "COMMON ACROSS LESSONS"

#### Requirements

Three instances with the following:

- Centos 7
- RAM >= 2GB

#### Getting Started

This lesson contains some scripts to automatically deploy and configure Sync Gateway with Couchbase Server. Download those scripts on each VM using wget.

```bash
ssh vagrant@192.168.34.11
wget https://cl.ly/1q300A3v3R1D/deploy.zip
sudo yum install -y unzip
unzip deploy.zip
```

Throughout this lesson, you will use different scripts located in the **deploy** folder.

[//]: # "COMMON ACROSS LESSONS"

## Architecture

The server-side architecture will be comprised of 2 nodes of Sync Gateway and 1 node of Couchbase Server. Each node will run on a different VM. The diagram below describes the architecture:

- Couchbase Server is running VM1
- Sync Gateway is running on VM2 and VM3

![](img/image74.png)

## Install Couchbase Server

To deploy Couchbase Mobile to production you must first get familiar with Couchbase Server. It can deployed on a whole host of [operating systems](http://www.couchbase.com/nosql-databases/downloads) and can scale horizontally with multiple nodes or vertically by increasing the VM specs. The following script downloads Couchbase Server and creates a new bucket called todo.

### Try it out

1. Log on VM1 (couchbase-server).
1. `cd deploy`
1. Run the **install\_couchbase\_server.sh** script.

    ```bash
    sudo ./install_couchbase_server.sh
    ```

1. Log on the Couchbase Server Admin Console on [http://VM1_IP:8091](http://VM1_IP:8091) with the user credentials that were created above (**Administrator/password**).

    <img src="https://cl.ly/2v400A2s0I2v/image68.gif" class="center-image" />

## Install Sync Gateway

Sync Gateway is the middleman server that exposes a database API for Couchbase Lite databases to replicate to and from. It connects internally to a Couchbase Server bucket to persist the documents.

In production, the configuration file should look similar to the one used in development except that instead of using **walrus:** for the bucket it will connect to an instance of Couchbase Server URL as shown below.

```javascript
{
  "interface":":4984",
  "log": ["HTTP", "Auth"],
  "databases": {
    "todo": {
      "server": "http://localhost:8091",
      "bucket": "todo",
      ...
    }
  }
}
```

The `install_sync_gateway.sh` script downloads and installs Sync Gateway 1.3. Then it restarts the `sync_gateway` service with the configuration file (`deploy/sync-gateway-config.json`) of the todo application.


### Try it out 

1. Log on VM2 (sync-gateway).
1. `cd deploy`
1. Run the Sync Gateway install script passing the IP of VM1 where Couchbase Server is running.

    ```bash
    sudo ./install_sync_gateway.sh VM1
    ```

1. Monitor the log file.

    ```bash
    sudo tail -f /home/sync_gateway/logs/sync_gateway_error.log
    ```

1. Send an `/{db}/_all_docs` request with a user's credentials. A user (**user1/pass**) is already defined in the Sync Gateway configuration file.

    ```bash
    curl -X GET 'http://user1:pass@localhost:4984/todo/_all_docs'
    ```

    ![](https://cl.ly/1j1q3p333D47/image75.gif)

1. Repeat the same steps on VM3 (sync-gateway).

## Using a reverse proxy

With two Sync Gateway nodes you can now configure the reverse proxy and update the sync endpoint in the mobile app to start replications pointing to the reverse proxy instead of an individual Sync Gateway instance. In this example the NGINX instance will run on VM4.

### Try it out

1. Log on VM4 (nginx).
1. `cd deploy`
1. Run the NGINX install script passing the IP of VM2 and VM3 where the Sync Gateway instances are running.

    ```bash
    sudo ./configure_nginx.sh VM2 VM3
    ```

1. Send an `/{db}/_all_docs` request with a user's credentials to the NGINX port. A user (**user1/pass**) is already defined in the Sync Gateway configuration file.

    ```bash
    curl -X GET 'http://user1:pass@localhost:8000/todo/_all_docs'
    ```

    ![](https://cl.ly/392N2E2K0J0T/image76.gif)


<block class="dockercloud">

# Docker Cloud

In this lesson you'll learn how to deploy Couchbase Server and Sync Gateway on Docker Cloud behind a load balancer.

## Launch node cluster

Launch a node cluster with the following settings:

* Provider: AWS
* Region: us-east-1 (or whatever region makes sense for you)
* VPC: Auto (if you don't choose auto, you will need to customize your security group)
* Type/Size: m3.medium or greater
* IAM Roles: None

![](img/docker_cloud_launch_nodecluster.png)

## Create Couchbase Server service

Go to **Services** and hit the **Create** button:

![](img/docker_cloud_service_create.png)

Click the globe icon and **Search Docker Hub** for `couchbase/server`.  You should select the `couchbase/server` image:

![](img/docker_cloud_create_cbs_service.png)

Hit the **Select** button and fill out the following values on the Services Wizard:

* Service Name: couchbaseserver
* Containers: 2
* Deployment strategy: High Availability
* Autorestart: On failure
* Network: bridge

![](img/docker_cloud_create_cbs_service2.png)

In the Ports section: Enable **published** on each port and set the Node Port to match the Container Port

![](img/docker_cloud_create_cbs_service3.png)

Hit the **Create and Deploy** button.  After a few minutes, you should see the Couchbase Server vervice running:

![](img/docker_cloud_couchbase_server_running.png)


## Configure Couchbase Server Container 1 + Create Buckets


Go to the **Container** section and choose **couchbaseserver-1**.  

![](img/docker_cloud_couchbase_container1.png)

Copy and paste the domain name (`eca0fe88-7fee-446b-b006-99e8cae0dabf.node.dockerapp.io`) into your browser, adding 8091 at the end (`eca0fe88-7fee-446b-b006-99e8cae0dabf.node.dockerapp.io:8091`)

You should now see the Couchbase Server setup screen:

![](img/docker_cloud_couchbase_setup.png)

You will need to find the *container IP* of Couchbase Server in order to configure it.  To do that, go to the **Terminal** section of **Containers/couchbaseserver-1**, and enter `ifconfig`.

![](img/docker_cloud_couchbase_container_terminal.png)

Look for the `ethwe1` interface and make a note of the ip: `10.7.0.2` -- you will need it in the next step.

Switch back to the browser on the Couchbase Server setup screen.  Leave the **Start a new cluster** button checked.  Enter the `10.7.0.2` ip address (or whatever was returned for your `ethwe1` interface) under the **Hostname** field.

![](img/docker_cloud_couchbase_server_hostname.png)

and hit the **Next** button.

For the rest of the wizard, you can:

- skip adding the samples
- skip adding the default bucket
- uncheck **Update Notifications**
- leave Product Registration fields blank
- check "I agree .."
- make sure to write down your password somewhere, otherwise you will be locked out of the web interface

Create a new bucket for your application:

![](img/docker_cloud_create_bucket.png)

## Configure Couchbase Server Container 2

Go to the **Container** section and choose **couchbaseserver-2**.  

As in the previous step, copy and paste the domain name (`4d8c7be0-3f47-471b-85df-d2471336af75.node.dockerapp.io`) into your browser, adding 8091 at the end (`4d8c7be0-3f47-471b-85df-d2471336af75.node.dockerapp.io:8091`)

Hit **Setup** and choose **Join a cluster now** with settings:

- IP Address: 10.7.0.2 (the IP address you setup the first Couchbase Server node with)
- Username: Administrator (unless you used a different username in the previous step)
- Password: enter the password you used in the previous step
- Configure Server Hostname: 10.7.0.3 (you can double check this by going to the **Terminal** for **Containers/couchbaseserver-2** and running `ifconfig` and looking for the ip of the `ethwe1` interface)

![](img/docker_cloud_join_couchbase_cluster.png)

Trigger a rebalance by hitting the **Rebalance** button:

![](img/docker_cloud_trigger_rebalance.png)

## Sync Gateway Service

Now create a Sync Gateway service.

Before going through the steps in the Docker Cloud web UI, you will need to have a Sync Gateway configuration somewhere on the publicly accessible internet.

*Warning: This is not a secure solution!  Do not use any sensitive passwords if you follow these steps*

To make it more secure, you could:

- Use a Volume mount and have Sync Gateway read the configuration from the container filesystem
- Use a HTTPS + Basic Auth for the URL that hosts the Sync Gateway configuration

Create a Sync Gateway configuration on a [github gist](https://gist.github.com/tleyden/f260b2d9b2ef828fadfad462f0014aed) and get the [raw url](https://gist.githubusercontent.com/tleyden/f260b2d9b2ef828fadfad462f0014aed/raw/8f544be6b265c0b57848b2ba36fb3e0f958ddcc9/gistfile1.txt) for the gist.

- Make sure to set the `server` value to `http://couchbaseserver:8091` so that it can connect to the Couchbase Service setup in a previous step.
- Use the bucket created in the Couchbase Server setup step above

In the Docker Cloud web UI, go to **Services** and hit the **Create** button again.

Click the globe icon and **Search Docker Hub** for `couchbase/sync-gateway`.  You should select the `couchbase/sync-gateway` image.

Hit the **Select** button and fill out the following values on the Services Wizard:

* Service Name: sync-gateway
* Containers: 2
* Deployment strategy: High Availability
* Autorestart: On failure
* Network: bridge

![](img/docker_cloud_sync_gateway_service.png)

In the **Container Configuration** section, customize the **Run Command** to use the raw URL of your gist, eg: `https://gist.githubusercontent.com/tleyden/f260b2d9b2ef828fadfad462f0014aed/raw/8f544be6b265c0b57848`

![](img/docker_cloud_configure_sg_service.png)

In the **Ports** section, use the following values:

![](img/docker_cloud_configure_sg_service_ports.png)

In the **Links** section, choose **couchbaseserver** and hit the **Plus** button

![](img/docker_cloud_sg_service_links.png)

Click the **Create and Deploy** button.

## Verify Sync Gateway

Click the **Containers** section and you should have two Couchbase Server and two Sync Gateway containers running.

![](img/docker_cloud_cbs_sg_containers.png)

Click the **sync-gateway-1** container and get the domain name (`eca0fe88-7fee-446b-b006-99e8cae0dabf.node.dockerapp.io`) and paste it in your browser with a trailing `:4984`, eg `eca0fe88-7fee-446b-b006-99e8cae0dabf.node.dockerapp.io:4984`

You should see the following JSON response:

```
{
   "couchdb":"Welcome",
   "vendor":{
      "name":"Couchbase Sync Gateway",
      "version":1.3
   },
   "version":"Couchbase Sync Gateway/1.3.1(16;f18e833)"
}
```


## Setup Load Balancer

Click the **Services** section and hit the **Create** button.  In the bottom right hand corner look for **Proxies** and choose **dockercloud/haproxy**

![](img/docker_cloud_create_load_balancer_service1.png)

General Settings:

- Service Name: sgloadbalancer
- Containers: 1
- Deployment Strategy: High Availability
- Autorestart: Always
- Network: Bridge

Ports:

- Port 80 should be **Published** and the **Node Port** should be set to `80`

Links:

- Choose **sync-gateway** and hit the **Plus** button

![](img/docker_cloud_haproxy_ports_links.png)

Hit the **Create and Deploy** button

## Verify Load Balancer

Click the **Containers** section and choose **sgloadbalancer-1**.

![](img/docker_cloud_sgloadbalancer_container.png)

Copy and paste the domain name (eg, `eca0fe88-7fee-446b-b006-99e8cae0dabf.node.dockerapp.io`) into your browser.

You should see the following JSON response:

```
{
   "couchdb":"Welcome",
   "vendor":{
      "name":"Couchbase Sync Gateway",
      "version":1.3
   },
   "version":"Couchbase Sync Gateway/1.3.1(16;f18e833)"
}
```

Congratulations!  You have just setup a Couchbase Server + Sync Gateway cluster on Docker Cloud.

<block class="all" />

## Conclusion

Well done! You've completed this lesson on installing Sync Gateway and Couchbase Server. In the next lesson you'll learn how to perform an upgrade on Sync Gateway. Feel free to share your feedback, findings or ask any questions on the forums.
