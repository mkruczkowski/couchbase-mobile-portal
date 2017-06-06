---
permalink: guides/couchbase-lite/native-api/attachment/index.html
---

<block class="all" />

### Blobs

We've renamed "attachments" to "blobs", for clarity. The new behavior should be clearer too: a {% st Blob|CBLBlob|Blob|Blob %} is now a normal object that can appear in a document as a property value. In other words, there's no special API for creating or accessing attachments; you just instantiate an {% st Blob|CBLBlob|Blob|Blob %} and set it as the value of a property, and then later you can get the property value, which will be a {% st Blob|CBLBlob|Blob|Blob %} object. The following code example adds a blob to the document under the `avatar` property.

<block class="swift" />

```swift
let appleImage = UIImage(named: "apple.jpg")
let imageData = UIImageJPEGRepresentation(appleImage, 1)!

let blob = Blob(contentType: "image/jpg", data: imageData)
newTask.set(blob, forKey: "avatar")
try database.save(newTask)

if let taskBlob = newTask.blob(forKey: "image") {
    UIImage(data: taskBlob.content!)
}
```

<block class="objc" />

```objectivec
UIImage *image = [UIImage imageNamed:@"avatar.jpg"];
NSData *data = UIImageJPEGRepresentation(image, 1);

CBLBlob *blob = [[CBLBlob alloc] initWithContentType:@"image/jpg" data:data];
[newTask setObject:blob forKey: "avatar"]

NSError* error;
[database saveDocument: newTask error:&error];
if (error) {
	NSLog(@"Cannot save document %@", error);
}

CBLBlob* taskBlob = [newTask blobForKey:@"avatar"];
UIImage* image = [UIImage imageWithData:taskBlob.content];

```

<block class="csharp" />

```csharp
var data = File.ReadAllBytes("avatar.jpg");
var blob = new Blob("image/jpg", data);
newTask.Set("avatar", blob);
database.Save(newTask);
var taskBlob = newTask.GetBlob("avatar");
var data = taskBlob.Content;
```

<block class="java" />

```java
InputStream inputStream = null;
try {
	inputStream = getAssets().open("avatar.jpg");
} catch (IOException e) {
	e.printStackTrace();
}

Blob blob = new Blob("image/jpg", inputStream);
newTask.set("avatar", blob);
database.save(newTask);

Blob taskBlob = newTask.getBlob("avatar");
byte[] data = taskBlob.getContent();
```

<block class="all" />

{% st Blob|CBLBlob|Blob|Blob %} itself has a simple API that lets you access the contents as in-memory data (a {% st Data|NSData|byte[]|byte[] %} object) or as a {% st InputStream|NSInputStream|Stream|InputStream %}. It also supports an optional `type` property that by convention stores the MIME type of the contents. Unlike attachments, blobs don't have names; if you need to associate a name you can put it in another document property, or make the filename be the property name (e.g. {% st document.set(imageBlob, forKey: "thumbnail.jpg")|[doc setObject: imageBlob forKey: @"thumbnail.jpg"]|doc.Set("thumbnail.jpg", imageBlob)|doc.set("avatar.jpg", imageBlob) %})

> **Note:** A blob is stored in the document's raw JSON as an object with a property `"_cbltype":"blob"`. It also has properties such as `"digest"` (a SHA-1 digest of the data), `"length"` (the length in bytes), and optionally `"type"` (the MIME type.) As always, the data is not stored in the document, but in a separate content-addressable store, indexed by the digest.