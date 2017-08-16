---
permalink: guides/couchbase-lite/native-api/query/index.html
---

<block class="java" />

⚠ Support in the current Developer Build is for Android only. The SDK cannot be used in Java applications.

<block class="all" />

Database queries have changed significantly. Instead of the map/reduce algorithm used in 1.x, they're now based on expressions, of the form "return ____ from documents where \_\_\_\_, ordered by \_\_\_\_", with semantics based on Couchbase Server's N1QL query language. If you've used {% tx Core Data|Core Data|LINQ|LINQ %}, or other query APIs based on SQL, you'll find this familiar.

## SELECT statement

With the SELECT statement, you can query and manipulate JSON data.

The following example queries the database for users who are not administrators and returns an array with the user's name for each user that satisfies the conditions.

<block class="swift" />

```swift
let query = Query
	.select(SelectResult.expression(Expression.property("name")))
	.from(DataSource.database(database))
	.where(
		Expression.property("type").equalTo("user")
		.and(Expression.property("admin").equalTo(false)
	)
)

do {
	let rows = try query.run()
	for row in rows {
		print("user name :: \(row.string(forKey: "name")!)")
	}
} catch let error {
	print(error.localizedDescription)
}
```

<block class="objc" />

```objectivec
CBLQuery* query = [CBLQuery select:@[[CBLQueryExpression property:@"name"]]
                              from:[CBLQueryDataSource database:database]
                             where:[
                                    [[CBLQueryExpression property:@"type"] equalTo:@"user"]
                                    and: [[CBLQueryExpression property:@"admin"] equalTo:@FALSE]]];

NSEnumerator* rows = [query run:&error];
for (CBLQueryRow *row in rows) {
    NSLog(@"user name :: %@", [row stringAtIndex:0]);
}
```

<block class="csharp" />

```csharp
var query = Query.Select()
	.From(DataSource.Database(database))
	.Where(
		Expression.Property("type").EqualTo("user")
		.And(Expression.Property("admin").EqualTo(false))
	);

var rows = query.Run();
foreach(var row in rows)
{
	Console.WriteLine($"doc ID :: ${row.DocumentID}");
}
```

<block class="java" />

```java
Query query = Query.select(SelectResult.expression(Expression.property("name")))
		.from(DataSource.database(database))
		.where(
			Expression.property("type").equalTo("user")
			.and(Expression.property("admin").equalTo(false))
		);

ResultSet rows = null;
try {
	rows = query.run();
} catch (CouchbaseLiteException e) {
	Log.e("app", "Failed to run query", e);
}
Result row;
while ((row = rows.next()) != null) {
	Log.d("app", String.format("user name :: %s", row.getString("name")));
}
```

<block class="all" />

With projections, you retrieve just the fields that you need and not the entire document. This is especially useful when querying for a large dataset as it results in shorter processing times and better performance.

There are several parts to specifying a query:

- SELECT: specifies the projection, which is the part of the document that is to be returned.
- FROM: specifies the database to query the documents from.
- WHERE: specifies the query criteria that the result must satisfy.
- GROUP BY: specifies the query criteria to group rows by.
- ORDER BY: specifies the query criteria to sort the rows in the result.

## JOIN statement

The JOIN clause enables you to create new input objects by combining two or more source objects.

<block class="swift" />

The following example uses a JOIN clause to find the airline details which have routes that start from RIX. This example JOINS the document of type "route" with documents of type "airline" using the document ID (`_id`) on the "airline" document and  `airlineid` on the "route" document.

```swift
let query = Query.select(
	SelectResult.expression(Expression.property("name").from("airline")),
	SelectResult.expression(Expression.property("callsign").from("airline")),
	SelectResult.expression(Expression.property("destinationairport").from("route")),
	SelectResult.expression(Expression.property("stops").from("route")),
	SelectResult.expression(Expression.property("airline").from("route"))
)
.from(
	DataSource.database(database!).as("airline")
)
.join(
	Join.join(DataSource.database(database!).as("route"))
	.on(
		Expression.meta().id.from("airline")
		.equalTo(Expression.property("airlineid").from("route"))
	)
)
.where(
	Expression.property("type").from("route").equalTo("route")
	.and(Expression.property("type").from("airline").equalTo("airline"))
	.and(Expression.property("sourceairport").from("route").equalTo("RIX"))
)
```

<block class="all" />

## GROUPBY statement

You can perform further processing on the data in your result set before the final projection is generated.

<block class="swift" />

The following example looks for the number of airports at an altitude of 300 ft or higher and groups the results by country and timezone.

<block class="swift" />

```swift
let query = Query.select(
		SelectResult.expression(Expression.property("country")),
		SelectResult.expression(Expression.property("tz"))
	)
	.from(DataSource.database(database!))
	.where(
		Expression.property("type").equalTo("airport")
		.and(Expression.property("geo.alt").greaterThanOrEqualTo(300))
	)
	.groupBy(
		Expression.property("country"),
		Expression.property("tz")
	)
```

#### Query methods

<block class="swift" />

{% include swift/query.html %}

<block class="swift" />

#### Expression methods

<block class="swift" />

{% include swift/expression.html %}

<block class="objc" />

#### Parameters

The list of available expressions can be found on the API reference of the `CBLQueryExpression` class.

[//]: # (TODO: #### Return Values)

[//]: # (TODO: #### Aggregation and Grouping)

<block class="objc" />

### NSPredicate API

The current Developer Build also supports the [NSPredicate](https://developer.apple.com/reference/foundation/nspredicate) query API. The {% st database.createQuery(where: NSPredicate?, groupBy: [Expression]?, having: Predicate?, returning: [Expression]?, distinct: Bool, orderBy: [SortDescriptor]?)|[database createQueryWhere:]|c|d %} method can be used to create an `NSPredicate` query.

Similarly to Core Data, we support the same Core Foundation classes:

1. Document criteria are expressed as an NSPredicate
2. The sort order is an array of NSSortDescriptors
3. The properties to return is an array of NSExpressions.

For convenience, you can provide these as NSStrings: document criteria will be interpreted as NSPredicate format strings, properties to return as NSExpression format strings, and sort orders as key-paths (optionally prefixed with “-” to indicate descending order.)

A CBLPredicateQuery object can be created by calling -createQueryWhere: method on CBLDatabase. After creating a query you can set additional attributes like grouping and ordering before running it.

#### Parameters

A query can have placeholder parameters that are filled in when it's run. This makes the query more flexible, and it improves performance since the query only has to be compiled once (see below.)

Parameters are specified in the usual way when constructing the NSPredicate. In the string-based syntax they're written as “`$`”-prefixed identifiers, like “`$MinPrice`”. (The “`$`” is not considered part of the parameter name.) If constructing the predicate as an object tree, you call `+[NSExpression expressionForVariable:]`.

The compiled CBLPredicateQuery has a property `parameters` , an NSDictionary that maps parameter names (minus the “`$`”!) to values. The values need to be JSON-compatible types. All parameters specified in the query need to be given values via the `parameters` property before running the query, otherwise you'll get an error.

#### Return Values

As in 1.x, running a CBLQuery returns an enumeration of CBLQueryRow objects. Each row's `documentID` property gives the ID of the associated document, and its `document` property loads the document object (at the cost of an extra database lookup.) But a query row can also return values directly, which is often faster than having to load the whole document.

To return values directly from query rows, set the query object's `returning:` property to an array of NSExpressions (or strings that parse to NSExpressions.) It's common to use key-paths, to return document properties directly, but you can add logic or computation.

To access the values returned by a CBLQueryRow, call any of the methods `-objectAtIndex:`, `integerAtIndex:`, etc., where the index corresponds to the index in the query's `returning:` array. Use the most appropriate method for the type of value returned; the numeric/boolean accessors are more efficient, as well as more convenient, because they avoid allocating NSNumber objects. `-stringAtIndex:` will return nil if the value is not a string (avoiding the possibility of an exception), and `-dateAtIndex:` additionally converts an ISO-8601 date string into an NSDate for you.

#### Aggregation and Grouping

If the return values of a query include calls to aggregate functions like `count()`, `min()` or `max()`, all of its rows will be combined together into one, with the aggregate functions operating on their parameters from all the rows.

If you set the query's `groupBy` property, all rows that have the same values of the expressions given in that property will be grouped together. In this case, aggregate functions will operate on the rows in a group, not all the rows of the query.

<block class="csharp java" />

### Live Query

A live query stays active and monitors the database and query index for changes. When there's a change it re-runs itself automatically, and if the query results changed it notifies any observers. The following code monitors query changes and prints the number of rows when a change occurs.

<block class="csharp" />

```csharp
var liveQuery = query.ToLive();
liveQuery.Changed += (sender, e) => {
	Console.WriteLine($"Number of rows :: {e.Rows.Count}");
};
liveQuery.Run();
```

<block class="java" />

```java
final LiveQuery liveQuery = query.toLive();
liveQuery.addChangeListener(new LiveQueryChangeListener() {
	@Override
	public void changed(LiveQueryChange change) {
		Log.d("query", String.format("Number of rows :: %s", change.getRows().toString()));
	}
});
liveQuery.run();
```

<block class="all" />

## Collection Operators

Collection operators enable you to evaluate expressions over collections or objects.

### IN operator

The `IN` operator evaluates to `TRUE` if the right-side value is an array and directly contains the left-side value.

<block class="swift" />

The following example uses the `IN` operator to find the airlines that are based in France or the United States.

```swift
let query = Query.select(
		SelectResult.expression(Expression.property("name"))
	)
	.from(DataSource.database(database!))
	.where(
		Expression.property("country").in(countries)
		.and(Expression.property("type").equalTo("airline"))
	)
```

Sometimes the conditions you want to filter need to be applied to the arrays nested inside the document. The `SATISFIES` keyword is used to specify the filter condition.

<block class="all" />

### Query Performance

Queries have to be parsed and compiled into an optimized form for the underlying database to execute. This doesn't take long, but it's best to create a {% st Query|CBLQuery|IQuery|Query %} once and then reuse it, instead of recreating it every time (of course, only reuse a {% st Query|CBLQuery|IQuery|Query %} on the same thread/queue you created it on).

Expression-based queries have different performance-vs-flexibility trade offs than map/reduce queries. Map functions can be unintuitive to design, and an individual map function isn't very flexible (all you can control is the range of keys). But any map/reduce query will be fast because, by definition, it's just a single traversal of an index.

On the other hand, expression-based queries are easier to design and more flexible, but there's no guarantee of performance. In fact, by default *all* queries will be unoptimized, because they have to make a linear scan of the entire database, testing every document against the criteria. In a small database you might not notice, but as the database grows, query time will increase linearly. So how do you make a query faster? By creating any necessary indexes.

### Indexing

A query can only be fast if there's a pre-existing database index it can search to narrow down the set of documents to examine. On the other hand, every index has to be updated whenever a document is updated, so too many indexes can hurt performance. Thus, good performance depends on designing and creating the *right* indexes to go along with your queries.

To create an index, call {% st createIndex(expressions: [Expression])|createIndexOn:error:|CreateIndex()|d %} passing an array of one or more strings. These are most often key-paths, but they don't have to be. If there are multiple expressions, the first one will be the primary key, the second the secondary key, etc.