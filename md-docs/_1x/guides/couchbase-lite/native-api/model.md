---
id: model
title: Model (iOS only)
permalink: guides/couchbase-lite/native-api/model/index.html
---

Most applications use the Model/View/Controller design pattern to separate user interface and user interaction from underlying data structures and logic. Of course, one of the responsibilities of the app's object model is persistence.

Couchbase Lite on iOS provides support for creating model objects that persist to Couchbase Lite documents, and can be queried using Couchbase Lite queries. (This functionality is similar to Core Data's NSManagedObject.) You subclass the abstract class CBLModel and add your own Objective-C properties, plus a very small amount of annotation that defines how those properties map to JSON in the document.

> **Note:** Model objects are currently only available in Objective-C. They may be added to the other implementations in the future, although the property-related features may be different in order to fit in with those platforms' idioms.

### What model objects give you

- **Native property access:** Access document properties as native Objective-C properties.
- **Extended type support:** Transparent support for common types that don't have a JSON representation, like NSDate and NSData. You can even represent references to other model objects.
- **Mutable state:** Properties can be `readwrite`, so they can be changed in memory, then later saved back to the document.
- **Key-Value Observing:** You can observe the value of a property and get notified when it changes. On Mac OS X, you can also use bindings to connect properties to UI controls.
- **Dynamic typing:** You can use the CBLModelFactory to associate each model class with a document type. You can create a hierarchy of model classes and have the appropriate subclass instantiated at runtime according to the document's type.

### Defining model classes

To create your own model class, just make it inherit from CBLModel. You can create any number of model classes, and they can inherit from each other. Each model class will correspond to a different type of persistent entity in your application.

You define persistent properties of your model classes simply by declaring Objective-C properties in its `@interface` block using the `@property` syntax. To mark a property as persistent, in the `@implementation` block you must declare it as being `@dynamic`, as shown in the next example.

> **Caution:** If you forget to declare a persistent property as `@dynamic`, the compiler will automatically synthesize a regular instance variable with getter/setter methods, so your program will compile and will appear to work except that the property won't be persistently saved to the document. This can be hard to debug! You can have the compiler flag missing `@dynamic` declarations by enabling the "Implicit Synthesized Properties" warning in the Xcode target build settings, but if you do this you'll also need to explicitly use `@synthesize` declarations for all synthesized properties.

<div class="tabs"></div>

```objective-c+
@interface Note : CBLModel
@property (copy) NSString* text;
@property NSDate* created;
@property bool checked;    // bool not BOOL! See below for why
@end
```

```swift+
@objc(Note)
class Note: CBLModel {
    @NSManaged var message: NSString
    @NSManaged var created: NSDate
    @NSManaged var checked: Bool
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

And here's the implementation of the class:

```objective-c
@implementation Note
@dynamic text, created, checked; // marks these as persistent
@end
```

This is, literally, all the code you need to write for a minimal but fully functional model class!

> **Note:** The name of the Objective-C property is exactly the same as the name of the JSON property in the document. If you're defining a model class for pre-existing documents, make sure you spell the property names the same way, including capitalization and underscores!

### Types of properties and how they're stored

CBLModel supports a pretty broad range of data types for properties, but not everything goes, and some types require special handling. Types that can't be directly represented in JSON — like dates — will be converted to a string representation, but will be properly converted back to the property's native type when the model object is next read from the database.

- **Numeric types:** All numeric types will be stored in JSON as numbers.
- **Booleans:** Declare boolean properties as the C99 type `bool`, not the legacy Objective-C type `BOOL`. (Why not? The latter is really just a typedef for `char`, so at runtime it just looks like an 8-bit integer, which means it'll be stored in JSON as 0 or 1, not true or false.)
- **NSString:** Maps to a JSON string, of course.
- **NSDate:** JSON doesn't have a date type, so the date will be stored as a string in the semi-standard ISO-8601 format, and parsed from that format when read in.
- **NSData:** JSON doesn't support binary data, so the data will be encoded as Base64 and stored as a string. (The size and CPU overhead of the conversion make this inefficient for large data. Consider using an attachment instead.)
- **Other CBLModel classes:** You can create a one-to-one references to another model object by declaring a persistent property whose type is a CBLModel subclass. The value will be persisted as a JSON string containing the document ID of the model object.
- **NSArray:** An NSArray is saved as a JSON array, with each element of the array converted to JSON according to the rules in this section. When reading a JSON array from a document, however, it can be ambiguous what type of object to use; there are annotations that can customize that. See below.
- **Any class implementing CBLJSONEncoding:** `CBLJSONEncoding` is an Objective-C protocol defined by Couchbase Lite. Any class of yours that implements this protocol can be used as the type of a persistent property; CBLModel will call the CBLJSONEncoding API to tell the object to convert itself to/from JSON.

> **Note:** If an object-valued property has a value of `nil`, its corresponding JSON property will be left out entirely when saving the document; it will _not_ be written with a JSON `null` as a value. Similarly, any missing property in the JSON will be converted to a nil or 0 or false value in Objective-C.

> **Note:** If a JSON value read from a document has a type that's incompatible with the corresponding model property — like a string when the property type is `int` — the model property will be set to the appropriate empty value (`0`, `false`, or `nil`). If you need stricter type matching, you should add a validation function to the Database, to ensure that documents have the correct JSON property types.

### Array element types

The `NSArray` property type often needs special handling, to ensure that the items of JSON arrays are converted to the correct type of object. By default, the items are simply parsed as JSON; this breaks round-trip fidelity if you store NSDate or NSData or CBLModel objects -- they'll all be read back in as NSStrings. And if you store objects implementing CBLJSONEncoding, they'll be read back in as whatever JSON-compatible value the object encoded itself as.

To prevent this, you can specify that the items of the array property must be of a particular class. Each item will then be converted from JSON according to the property-type rules for that class, described in the previous section. To specify the type, implement a class method with a name of the form property name ItemClass, as in this example:

<div class="tabs"></div>

```objective-c+
@interface Star : CBLModel
@property (copy) NSArray* observationDates;  // items are NSDates
@end
//
@implementation Star
@dynamic observationDates;
// Declares that the items of the observations property are NSDates.
+ (Class) observationsItemClass {
    return [NSDate class];
}
@end
```

```swift+
@objc(Star)
class Star: CBLModel {
    @NSManaged var observationDates: NSArray // items are NSDates
    class func observationsItemClass() -> AnyClass {
        return NSDate.self
    }
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

### Raw access to document properties

You don't _have_ to create an Objective-C property for every document property. It's possible to access arbitrary document properties by name, by calling `-getValueOfProperty:` and `-setValue:ofProperty:`.

<div class="tabs"></div>

```objective-c+
// Let's say Note documents have a JSON property "type" that we haven't
// defined a property for. We can access it like this:
NSString* noteType = [note getValueOfProperty: @"type"];
[note setValue: noteType ofProperty: @"type"];
```

```swift+
// Let's say Note documents have a JSON property "type" that we haven't
// defined a property for. We can access it like this:
let noteType = note.getValueOfProperty("type") as String
note.setValue(noteType, ofProperty: "type")
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

### Attachments

Model objects also support access to document attachments. The API is very similar to that of the UnsavedRevision class: you can access attachments using the attachmentNames property and attachmentNamed method, and modify attachments using setAttachmentNamed and removeAttachmentNamed. (Changes to attachments aren't saved to the database until the model object is saved.)

## Instantiating model objects

Remember that every model has a one-to-one association with a document in the database. **CBLModel** has no public initializer methods, and you should not implement any yourself in subclasses.

To create a new model object on a new document, use the following class method:

<div class="tabs"></div>

```objective-c+
Note* newNote = [Note modelForNewDocumentInDatabase: self.database];
```

```swift+
let newNote = Note(forNewDocumentInDatabase: self.database);
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

In a subclass, to set up a transient state of an instance, override the `awakeFromInitializer` instance method. This method is called when a new model is instantiating.

To instantiate the model for an existing document (or even a document that doesn't exist yet but which you want to have a specific ID):

<div class="tabs"></div>

```objective-c+
CBLDocument* doc = self.database[@"some-note"];
Note* note = [Note modelForDocument: doc];
```

```swift+
let doc = self.database["some-note"]
let note = Note(forDocument: doc)
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

The `+modelForDocument:` method is inherited from CBLModel; you don't need to override it. But it always creates an instance of the class that it's invoked on, `Note` in the example.

> **Note:** There is never more than one model object for a particular document. If you call `+modelForDocument:` again on the same CBLDocument, it will return the same model object.

### Custom initialization

If your subclass needs to initialize state when it's created, you should create a class method with the desired parameters and call the `modelForDocumentInDatabase` class method:

<div class="tabs"></div>

```objective-c+
@interface Note : CBLModel
@property (copy) NSString* title;
@end
  
@implementation Note
@dynamic title;
  
+ (Note*) newNoteInDatabase:(CBLDatabase*) database withTitle:(NSString*) title {
    Note* note = [Note modelForNewDocumentInDatabase:database];
    note.title = title;
    return note;
}
  
@end
```

```swift+
class Note: CBLModel {
    @NSManaged var title: String
    
    class func newNoteInDatabase(database: CBLDatabase, withTitle title: String) -> Note {
        let note = Note(forNewDocumentInDatabase: database)
        note.title = title
        return note
    }
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

### Dynamic instantiation using the model factory

There's one limitation of the default mechanism of instantiating model objects: you have to know what class the model object will be before you instantiate it, since you call `+modelForDocument:` on that specific class. This can be a problem if you have a hierarchy of model classes, and want to instantiate different subclasses for different types of documents.

For example, let's say you have a fancy to-do list that supports not just text notes but voice notes and picture notes. You've created `VoiceNote` and `PictureNote` subclasses of `Note` for these, and the documents in the database follow the convention of using a `"type"` property to identify their type, with values `"note"`, `"voice_note"` and `"picture_note"`. Now, any time you want to instantiate a model object, it seems you'll first have to look at the document's `"type"` property, match the value to a `Note` class, and instantiate that class:

<div class="tabs"></div>

```objectice-c+
// This is the CLUMSY and INEFFICIENT way to handle dynamic typing:
CBLDocument* doc = self.database[@"some-note"];
Note* note;
NSString* type = doc[@"type"];
if ([type isEqualToString: @"note"]) {
    note = [Note modelForDocument: doc];
} else if ([type isEqualToString: @"voice_note"]) {
    note = [VoiceNote modelForDocument: doc];
} else if ([type isEqualToString: @"picture_note"]) {
    note = [PictureNote modelForDocument: doc];
} else {
    note = nil;
}
```

```swift+
// This is the CLUMSY and INEFFICIENT way to handle dynamic typing:
let doc = self.database["some-note"]
var note: Note?
let type = doc["type"] as? String;
if type == "note" {
    note = Note(forDocument: doc)
} else if type == "voice_note" {
    note = VoiceNote(forDocument: doc)
} else if type == "picture_note" {
    note = PictureNote(forDocument: doc)
} else {
    note = nil
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

Even worse, let's say you have a model class that has a reference to a Note, i.e. a property of type `Note*`. When 
resolving this property value, CBLModel will instantiate a `Note` object, even if the document's type indicates it should be represented by a `VoiceNote` or `PictureNote`!

To solve these problems, register your model classes with the database's ModelFactory, specifying a different `"type"` value for each one:

<div class="tabs"></div>

```objective-c+
// Do this once per launch, probably right after opening the database:
CBLModelFactory* factory = self.database.modelFactory;
[factory registerClass: [Note class] forType: @"note"];
[factory registerClass: [VoiceNote class] forType: @"voice_note"];
[factory registerClass: [PictureNote class] forType: @"picture_note"];
```

```swift+
// Do this once per launch, probably right after opening the database:
let factory = self.database.modelFactory
factory.registerClass(Note.self, forDocumentType: "note")
factory.registerClass(VoiceNote.self, forDocumentType: "voice_note")
factory.registerClass(PictureNote.self, forDocumentType: "picture_note")
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

Once you've done this, you can now call `+modelForDocument:` directly on CBLModel, instead of on your subclass; the method will look up the document's type in the model factory to find out what class to instantiate.

<div class="tabs"></div>

```objective-c+
// This is the clean way to handle dynamic typing:
CBLDocument* doc = self.database[@"some-note"];
Note* note = (Note*)[CBLModel modelForDocument: doc];
```

```swift+
// This is the clean way to handle dynamic typing:
let doc = self.database["some-note"]
let note = CBLModel(forDocument: doc) as Note
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

This doesn't look much different from the usual style; but by letting CBLModel choose the class, you'll dynamically get an object of the correct subclass (Note, VoiceNote or PictureNote) based on the `"type"` property of the individual document. Also, when resolving a property value whose type is a model class, the factory will be used to ensure that the correct subclass is instantiated.

> **Note:** For this to work, you do have to make sure your model object sets the document's "type" property appropriately!

## Saving model objects

Model objects can have mutable state: their properties can be declared `readwrite`, and their attachments can be modified. Such changes are made only in memory, and don't affect the underlying Document until the model object is saved.

<div class="tabs"></div>

```objective-c+
// Toggle a note's checkbox property and save it:
note.checked = !note.checked;
NSError* error;
if (![note save: &error])
    [self handleError: error];
```

```swift+
// Toggle a note's checkbox property and save it:
note.checked = !note.checked
var error: NSError?
if !note.save(&error) {
    handleError(error)
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

> **Tip:** You can efficiently save all changed models at once, by calling the database's `saveAllModels` method.

If you don't want to deal with saving manually, you can set a model object's `autosaves` property. When this boolean property is set, the model will automatically call `save:` shortly after its state is changed. (The save occurs after the current thread returns back to the runloop, and only happens once even if multiple changes were made.)

> **Tip:** You can increase the delay before the auto-save by overriding the `autosaveDelay` property, whose default value is 0, to a longer time interval.

If instead you want to undo all changes and revert the model object back to the document's state, call `revertChanges`.

To delete the document, call `deleteDocument:`. (Afterwards, don't use the model object anymore; with a deleted document it's no longer in a useable state.)

### Customizing saving

If you need to do something just before a model is saved, don't override `save` -- it isn't called in all cases where the model gets saved. Instead, override `willSave`. This is guaranteed to be called right before a save. It's passed a set of the names of all the modified properties, which could be useful. Your implementation can even change property values if it wants to, for instance to update a timestamp:

<div class="tabs"></div>

```objective-c+
- (void) willSave: (NSSet*)changedPropertyNames {
    self.saveCount++;
    self.lastSavedTime = [NSDate date];
}
```

```swift+
override func willSave(changedPropertyNames: NSSet!) {
    saveCount++
    lastSaveTime = NSDate()
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

You may need a specific type of customization when deleting a model's document: storing some information in the deleted document's "tombstone" revision, generally for the use of the server. To do this, override `propertiesToSaveForDeletion` and return an NSDictionary of properties. It's best to call the base implementation and modify the dictionary it returns:

<div class="tabs"></div>

```objective-c+
- (NSDictionary*) propertiesToSaveForDeletion {
    NSMutableDictionary* props = [[super propertiesToSaveForDeletion] mutableCopy];
    props[@"timestamp"] = [CBLJSON JSONObjectWithDate: [NSDate date]];
    return props;
}
```

```swift+
override func propertiesToSaveForDeletion() -> [NSObject : AnyObject]! {
    var props = super.propertiesToSaveForDeletion()
    props["timestamp"] = CBLJSON.JSONObjectWithDate(NSDate())
    return props
}
```

```java+
No code example is currently available.
```

```android+
No code example is currently available.
```

```c+
No code example is currently available.
```

Sometimes you don't want to save immediately, but you want to get the model's current state as a JSON object, i.e. the data that _would_ be saved to the document. The `propertiesToSave` method returns this.