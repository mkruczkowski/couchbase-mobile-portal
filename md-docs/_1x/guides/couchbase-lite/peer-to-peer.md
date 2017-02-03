---
id: peer-to-peer
title: Peer-to-peer
---

The Listener enables any Couchbase Lite database to become the remote in a replication by listening on a TCP port and by exposing the standard replication endpoints on that port.

![](img/docs-listener-diagram.png)

It becomes an alternate entry-point into the data store. Another peer can therefor use the URL and port number in the replicator to sync data to and from the database currently listening.

Some typical Listener use cases include:


- Trusted peers only: sync based on a QR code secret, ultrasound etc.
- Peers within a security group: authentication based on peer discovery.
- Wide open: experimental social messaging apps.
- Offline/online: use peer-to-peer in conjunction with Sync Gateway.

### Installing the Listener library

Refer to the [installation guide](./../../../installation/index.html) of the platform of your choice to install the 
Listener component. The Couchbase Lite Listener is coupled to Couchbase Lite. Both frameworks should always be running the same release version.

### Configuring

To begin using the Listener you must create an instance by specifying a manager instance and port number:

<div class="tabs"></div>

```objective-c+
CBLManager* manager = [CBLManager sharedInstance];
CBLListener* listener = [[CBLListener alloc] initWithManager:manager port:55000];
```

```swift+
let manager = CBLManager.sharedInstance()
let listener = CBLListener(manager: manager, port: 55000)
```

```java+android+
Manager manager = new Manager((Context) getApplicationContext(), Manager.DEFAULT_OPTIONS);
LiteListener listener = new LiteListener(manager, 55000, null);
Thread thread = new Thread(listener);
thread.start();
```

```c+
Manager manager = Manager.SharedInstance;
CouchbaseLiteTcpListener listener = new CouchbaseLiteTcpListener (manager, 55000);
listener.Start();
```

## Discovery

Once you have set up the Listener as an endpoint for other peers to replicate to or from, you can use different discovery methods to browse for peers and subscribe to those of interest.

This section covers two ways to discover peers:

- Using a QR code to encode the peer's remote URL.
- Bonjour.

### QR code

#### PhotoDrop

[PhotoDrop](https://github.com/couchbaselabs/photo-drop) is a P2P sharing app similar to the iOS AirDrop feature that you can use to send photos across devices. The source code is available for iOS and Android. The QR code is used for advertising an adhoc endpoint URL that a sender can scan and send photos to.

### Bonjour

The first step to using Bonjour for peer discovery is to advertize a service with the following properties:

- **Type:** Bonjour can be used by many other devices on the LAN (printers, scanners, other apps etc). The service type is a way to interact only with peers whose service type is the same.
- **Name:** A string to serve as identifier for other peers. It should be unique for each peer.
- **Port:** The port number the Listener is running on.
- **Metadata:** Optional data that will be sent in the advertizment packets (the size limit is around 15KB).

	> **Note:** Bonjour browsers are useful to monitor devices broadcasting a particular service on the LAN ([OS X Bonjour browser](http://www.macupdate.com/app/mac/13388/bonjour-browser), [iOS app](https://itunes.apple.com/gb/app/discovery-bonjour-browser/id305441017), [Windows browser](http://hobbyistsoftware.com/bonjourbrowser))

Given a service type, you can use an API to browse for all services with that service type. Various callback methods are invoked as peers on the network go online and offline.

![](img/docs-peer-discover-diagram.png)

Once the IP is resolved in step 3, the replication with that peer can be started in step 4. The following sections cover the different callbacks for the **advertiser** (device A) and **subscriber** (device B).

#### Advertiser

Start a listener with the following.

<div class="tabs"></div>

```objective-c+
[listener setBonjourName:@"chef123" type:@"_myapp._tcp"];
```

```swift+
listener.setBonjourName("chef123", type: "_myapp._tcp")
```

```java+
JmDNS jmdns = new JmDNS();
  
ServiceInfo serviceInfo = ServiceInfo.create("_myapp._tcp", "chef123", 55000, "A service description");
jmdns.registerService(serviceInfo);
```

```android+
// Create the NsdServiceInfo object, and populate it.
NsdServiceInfo serviceInfo = new NsdServiceInfo();
  
serviceInfo.setServiceName("chef123");
serviceInfo.setServiceType("_myapp._tcp);
serviceInfo.setPort(55000);
nsdManager.registerService(serviceInfo, NsdManager.PROTOCOL_DNS_SD, registrationListener);
// registrationListener is an instance of NsdManager.RegistrationListener
```

```c+
No code example is currently available.
```

#### Subscriber

To browse for peers on the network, each implementation has an asynchronous API to get notified as peers go online and offline from the network. You must implement the protocol or interface before starting the network discovery.

- Bonjour: Implement the `NSNetServiceBrowserDelegate` protocol
- NSD: Create a new instance of the `NsdManager.DiscoveryListener` class
- JmDNS: Implement the `ServiceListener` interface

After setting the listener or delegate, create a new instance of the discovery object.

<div class="tabs"></div>

```objective-c+
NSNetServiceBrowser* browser = [NSNetServiceBrowser new];
browser.includesPeerToPeer = YES;
browser.delegate = self;
[browser searchForServicesOfType:@"_myapp._tcp" inDomain:@"local."];
```

```swift+
browser = NSNetServiceBrowser.new()
browser.includesPeerToPeer = true
browser.delegate = self
browser.searchForServiceOfType("_myapp._tcp", inDomain: "local.")
```

```java+
jmdns.addServiceListener("_myapp._tcp", new DiscoveryListener(database, jmdns, serviceName));
```

```android+
mNsdManager.discoverServices("_myapp._tcp", NsdManager.PROTOCOL_DNS_SD, mDiscoveryListener);
// mDiscoveryListener is an instance of NsdManager.DiscoveryListener
```

```c+
No code example is currently available.
```

#### Hostname resolution

The hostname resolution can be done in the listener/protocol you have implemented previously.

<div class="tabs"></div>

```objective-c+
- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
  // Start async resolve, to find service's hostname
  service.delegate = self;
  [service resolveWithTimeout:5];
}
```

```swift+
public func netServiceBrowser(browser: NSNetServiceBrowser, didFindService service:   NSNetService, moreComing: Bool) {
  // Start async resolve, to find service's hostname
  service.delegate = self
  service.resolveWithTimeout(5.0)
}
```

```java+
@Override
public void serviceAdded(ServiceEvent event) {
  jmdns.requestServiceInfo(event.getType(), event.getName(), 10);
}
```

```android+
@Override
public void onServiceFound(NsdServiceInfo service) {
  nsdManager.resolveService(serviceInfo, resolveListener);
  // Instance of NsdManager.ResolveListener
}
```

```c+
No code example is currently available.
```

When the IP is received, the corresponding method will get called at which point the replication can be started.

<div class="tabs"></div>

```objective-c+
// NSNetService delegate callback
- (void) netServiceDidResolveAddress:(NSNetService *)service {
    // Construct the remote DB URL
    NSURLComponents* components = [[NSURLComponents alloc] init];
    components.scheme = @"http"; // Or "https" uf peer uses SSL
    components.host = service.hostName;
    components.port = [NSNumber numberWithInt:service.port];
    components.path = [NSString stringWithFormat:@"/@%", remoteDatabaseName];
    NSURL* url = [components URL];
      
    // Start replications
    CBLReplication* push = [database createPushReplication:url];
    CBLReplication* pull = [database createPullReplication:url];
    [push start];
    [pull start];
}
```

```swift+
// NSNetService delegate callback
func netServiceDidResolveAddress(service: NSNetService) {
    // Construct the remote DB URL
    let components = NSURLComponents()
    components.scheme = "http" // Or "https" if peer uses SSL
    components.host = service.hostName!
    components.port = service.port
    components.path = "/" + remoteDatabaseName
    let url = components.URL!
    
    // Start replications
    let push = database?.createPushReplication(url)!
    let pull = database?.createPullReplication(url)!
    push?.start()
    pull?.start()
}
```

```java+
@Override
public void serviceResolved(ServiceEvent event) {
  System.out.println("RESOLVED");
  String[] serviceUrls = event.getInfo().getURLs();
  try {
    URL url = new URL(serviceUrls[0]);
    Replication pullReplication = database.createPullReplication(url);
    pullReplication.setContinuous(true);
    pullReplication.start();
    Replication pushReplication = database.createPushReplication(url);
    pushReplication.setContinuous(true);
    pushReplication.start();
  } catch (IOException e){
    throw new RuntimeException(e);
  }
}
```

```android+
@Override
public void onServiceResolved(NsdServiceInfo serviceInfo) {
    Log.e(Application.TAG, "Resolve Succeeded. " + serviceInfo);
    String remoteStringURL = String.format("http:/%s:%d/%s",
            serviceInfo.getHost(),
            serviceInfo.getPort(),
            StorageManager.databaseName);
    URL remoteURL = null;
    try {
        remoteURL = new URL(remoteStringURL);
    } catch (MalformedURLException e) {
        e.printStackTrace();
    }
    Database database = StorageManager.getInstance().database;
    Replication push = database.createPushReplication(remoteURL);
    Replication pull = database.createPullReplication(remoteURL);
    push.setContinuous(true);
    pull.setContinuous(true);
    push.start();
    pull.start();
}
```

```c+
No code example is currently available.
```

#### Resources

Useful resources to work with mDNS include:

- **Bonjour for iOS and Mac applications:** The Couchbase Lite SDK exposes part of the Bonjour API for an easier integration. The official documentation for iOS and Mac applications can be found in the [NSNetService Programming Guide](https://developer.apple.com/library/mac/documentation/Networking/Conceptual/NSNetServiceProgGuide/Introduction.html).
- **NSD for Android applications:** The de facto framework for Android is called Network Service Discovery (NSD) and is compatible with Bonjour since Android 4.1. The official guide can be found in the [Android NSD guide](https://developer.android.com/training/connect-devices-wirelessly/nsd.html).
- **JmDNS:** Implementation in Java that can be used in Android and Java applications ([official repository](https://github.com/jmdns/jmdns)).

## Connecting

Once the IP address of another device is known you can start replicating data to or from that peer. However, there are some good practice guidelines to follow in order to replicate the changes as they are persisted to a particular node.

### Filter functions

It may be desirable to use [filter functions](./../native-api/replication/index.html#filtered-replications) to replicate only the documents
 of interest to another peer. Filter functions in a peer-to-peer context are executed when the start method on the replication object is called. This is a major difference with the Sync Function available on Sync Gateway that builds the access rules when documents are saved to the Sync Gateway database.

### Port allocation

If the port number passed to the Listener is hardcoded, there is a small chance that another application may already be using it. To avoid this scenario, specifying a value of 0 for the port in the Listener constructor will let the TCP stack pick a random available port.

### Remote UUID

The replication algorithm keeps track of what was last synchronized with a particular remote database. To identify a remote, it stores a hash of the remote URL http://hostname:port/dbname and other properties such as filters, filter params etc. In the context of peer-to-peer, the IP address will frequently change which will result in a replication starting from scratch and sending over every single document although they may have already been replicated in the past. You can override the method of identifying a remote database using the remoteUUID property of the replicator. If specified, it will be used in place of the remote URL for calculating the remote checkpoint in the replication process.

## Security

Basic authentication is the recommended approach for protecting database access on the LAN. The listening peer must provide the username/password pair when instantiating the Listener.

<div class="tabs"></div>

```objective-c+
CBLListener* listener = [[CBLListener alloc] initWithManager:manager port:0];
listener.passwords = @{@"hello": @"pw123"};
[listener start:nil];  
```

```swift+
var listener: CBLListener = CBLListener(manager: manager, port: 0)
listener.passwords = ["hello": "pw123"]
listener.start(nil)
```

```java+
Credentials credentials = new Credentials("hello", "pw123");
LiteListener liteListener = new LiteListener(manager, 0, credentials);
liteListener.start();
```

```android+
Credentials credentials = new Credentials("hello", "pw123");
LiteListener liteListener = new LiteListener(manager, 0, credentials);
liteListener.start();
```

```c+
CouchbaseLiteTcpListener listener = new CouchbaseLiteTcpListener (manager, 0, CouchbaseLiteTcpOptions.AllowBasicAuth);
listener.SetPasswords(new Dictionary<string, string>() { { "hello", "pw123" } });
listener.Start ();
```

The peer that intends to run the replication must provide the same username/password http://username:password@hostname:port/dbname.

### SSL for Peer-to-peer

<div class="tabs"></div>

```objective-c+
if (![listener setAnonymousSSLIdentityWithLabel: @"MyApp SSL" error: &error])
    // handle error
```

```swift+
if !listener.setAnonymousSSLIdentityWithLabel("MyApp SSL", error: error) {
   // handle error }
```

```java+android+
No code example is currently available.
```

```c+
var path = System.IO.Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "unit_test.pfx");
var cert = X509Manager.GetPersistentCertificate("127.0.0.1", "123abc", path);
CouchbaseLiteTcpListener listener = new CouchbaseLiteTcpListener(manager, 0, CouchbaseLiteTcpOptions.UseTLS, cert);
```

The Listener is now serving SSL using an automatically generated identity.

#### Wait, Is This Secure?

Yes and no. It encrypts the connection, which is unquestionably much better than not using SSL. But unlike the usual SSL-in-a-browser approach you're used to, it doesn't identify the server/listener to the client. The client has to take the cert on faith the first time it connects.