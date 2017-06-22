---
permalink: guides/couchbase-lite/tech-notes/index.html
---

<block class="swift objc csharp" />

This content on this page is not yet available for this platform.

<block class="java" />

This section will give you an overview of the Couchbase Lite codebase, its conventions and the implementation.

## Add Couchbase Lite from Source

It can be preferable to have Couchbase Lite built from source in your project for the following reasons:

- You wish to insert a breakpoint in the Couchbase Lite source code.
- You wish to make a code change and run it against your application.

### In Android Studio

To add Couchbase Lite as a sub-project in Android Studio, run the following steps:

1. Clone the `couchbase/couchbase-lite-android` repository in your project and check out on the `feature/2.0` branch.

	```bash
	cd <project_root>
	mkdir -p libs
	cd libs
	git clone https://github.com/couchbase/couchbase-lite-android.git
	cd couchbase-lite-android/
	git checkout feature/2.0
	git submodule update --init --recursive
	```

2. Open **project_root/settings.gradle** in your project and add the following.

	```bash
	':libs:couchbase-lite-android:android:CouchbaseLite'
	```

3. Edit the top level file **project_root/build.gradle** file.

	```groovy
	buildscript {
		dependencies {
			...
	
			classpath 'com.jfrog.bintray.gradle:gradle-bintray-plugin:1.7.3'
		}
	}
	```

4. Add the following in the module level build file **project_root/app/build.gradle**.

	```groovy
	compile project(':libs:couchbase-lite-android:android:CouchbaseLite')
	```

5. To build Couchbase Lite Android from source you must have the Android NDK installed. Follow [the instructions](https://developer.android.com/ndk/guides/index.html) to install it and specify its location by adding the following line in **local.properties** of your project.

	```bash
	ndk.dir=/Users/path/to/android-ndk-r14b
	```

6. Select the **Tools > Android > Sync Project with Gradle files** menu and start using Couchbase Lite in your project.

<block class="swift" />

<block class="objc" />

<block class="csharp" />