---
id: performance-testing
title: Performance Testing
permalink: ready/training/test/performance-testing/index.html
---

In this lesson you'll learn how to perform performance tests on your Couchbase Mobile application. You'll test the performance of Sync Gateway.

[//]: # "COMMON ACROSS LESSONS"

#### Requirements

- 3 x VMs with RAM >= 2GB
- Node.js 0.6.6 or higher

#### Getting Started

This lesson contains some scripts to run performance tests. Download those scripts below

```bash
wget https://cl.ly/3Z0D2D0l3R0O/test.zip
sudo apt-get install unzip
unzip test.zip
```

Throughout this lesson, you will use different scripts located in the **test** folder.

[//]: # "COMMON ACROSS LESSONS"

## Testing environment

It's preferable to run performance tests on an environment that would closely ressemble your production environment. If you haven't determined the production environment yet then performance testing can help evaluate that based on the expected load of the application. To follow this lesson you must already have a reverse proxy (prerably NGINX) load balancing to 2 Sync Gateway nodes backed by 1 Couchbase Server instances.

> **Tip:** If you don't have this setup you can jump to the **Deploy > Install** lesson to do so.

You will use a Node.js script to generate some load on the Sync Gateway instances. You will have the option to specify the following parameters.

|Name|Definition|
|:-------|:-------|
|`url`|The URL of the Sync Gateway instance under test.|
|`concurrency`|The number of concurrent users sending requests simultaneously.|

All scenarios will run for 20 seconds. The result of the test will contain the following.

|Name|Definition|
|:-------|:-------|
|Completed requests|The total number of requests sent in that time.|
|Mean latency|The average time it took for an operation to complete.|
|P50|50% of the requests sent took less time than the P50 value.|
|P90|90% of the requests sent took less time than the P90 value.|
|P95|95% of the requests sent took less time than the P95 value.|
|P99|99% of the requests sent took less time than the P99 value.|

## Read performance

In this scenario you will query the database endpoint and measure the time it takes for each request to complete. The code below starts the timer, then sends a GET `/{db}` request and measures the time of the response.

```javascript
  function makeRequest() {
    var start_time = process.hrtime();

    WriteAndReadDocument()
      .then(function () {
        results.totalRequests++;
        var hr_time = process.hrtime(start_time);
        var elapsed_time = hr_time[0] * 1000 + hr_time[1] / 1000000;
        results.totalTime += elapsed_time;
        var rounded = Math.floor(elapsed_time);
        if (rounded > results.maxLatencyMs) {
          results.maxLatencyMs = rounded;
        }
        if (!results.histogramMs[rounded]) {
          results.histogramMs[rounded] = 0;
        }
        results.histogramMs[rounded] += 1;
      })
      .then(function() {
        makeRequest();
      });
    
  }

  function GetDatabaseEndpoint () {
    return client.database.get_db({db: 'todo'});
  }
```

### Try it out

1. Run the test.
2. Evaluate the results.

    ```
    Target URL:          http://user1:pass@138.68.159.166:8000/

    Completed requests:  22
    Mean latency:        2384.2 ms

    Percentage of the requests served within a certain time
    50%      2122 ms
    90%      3553 ms
    95%      3556 ms
    99%      5415 ms
    ```

## Write and Read performance

In this scenario you will query the database endpoint and measure the time it takes for each request to complete. The code below inserts a document and then queries the same document ID with a GET `/{db}/{id}` request and measures the time of both operations.

```javascript
  function makeRequest() {
    var start_time = process.hrtime();

    WriteAndReadDocument()
      .then(function () {
        results.totalRequests++;
        var hr_time = process.hrtime(start_time);
        var elapsed_time = hr_time[0] * 1000 + hr_time[1] / 1000000;
        results.totalTime += elapsed_time;
        var rounded = Math.floor(elapsed_time);
        if (rounded > results.maxLatencyMs) {
          results.maxLatencyMs = rounded;
        }
        if (!results.histogramMs[rounded]) {
          results.histogramMs[rounded] = 0;
        }
        results.histogramMs[rounded] += 1;
      })
      .then(function() {
        makeRequest();
      });
    
  }
  
  function WriteAndReadDocument() {
    var list = {"_id": "user1." + guid(), "name": "Groceries", "owner": "user1", "type": "task-list"};
    return client.document.post({db: 'todo', body: list})
      .then(function (res) {
        return client.document.get({db: 'todo', doc: list._id});
      })
      .catch(function (err) {console.log(err)});
  }
```

### Try it out

1. Run the test.
2. Evaluate the results.

    ```
    Target URL:          http://user1:pass@138.68.159.166:8000/

    Completed requests:  639
    Mean latency:        184.7 ms

    Percentage of the requests served within a certain time
    50%      178 ms
    90%      262 ms
    95%      289 ms
    99%      367 ms
    ```

## Conclusion

Well done! You've completed this lesson on functional testing. In the next lesson you'll learn how to deploy Sync Gateway and Couchbase Server. Feel free to share your feedback, findings or ask any questions on the forums.