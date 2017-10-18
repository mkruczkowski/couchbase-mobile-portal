---
id: scale
title: Scale
permalink: training/deploy/scale/index.html
---

In this lesson you'll learn how to scale Sync Gateway and Couchbase Server in real-time with zero downtime.

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

In this lesson you will deploy a 3rd Sync Gateway node behind the reverse proxy.

![](img/image80.png)

## Scaling Sync Gateway

Similarly to previous lessons you will first deploy Sync Gateway with the configuration file passing the IP of the VM running Couchbase Server.

There will be 3 Sync Gateway nodes but the reverse proxy is forwarding the load to only 2 of them. To balance the traffic across all 3 you must update the NGINX config file with the IP of VM5.

### Try it out

1. Log on VM5 (sync-gateway).
1. `cd deploy`
1. Run the Sync Gateway install latest script passing the IP of VM1 where Couchbase Server is running.

    ```bash
    sudo ./install_latest_sync_gateway.sh VM1
    ```

1. Log on VM4 (nginx).
1. Run the NGINX install script passing the IP of VM2, VM3 and VM4 where the Sync Gateway instances are running.

    ```bash
    sudo ./configure_nginx.sh VM2 VM3 VM5
    ```

1. Send a curl request to http://localhost:8000. This will return information about the running sync_gateway behind the reverse proxy.

    ```bash
    curl localhost:8000
    ```

    ![](https://cl.ly/392N2E2K0J0T/image76.gif)

<block class="all" />

## Conclusion

Well done! You've completed this lesson on scaling. Feel free to share your feedback, findings or ask any questions on the forums.
