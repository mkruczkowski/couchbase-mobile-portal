---
id: cbl-encryption
title: CBL Encryption
permalink: guides/couchbase-lite/tech-notes/cbl-encryption/index.html
---

You can encrypt an entire Couchbase Lite database. The algorithm used is AES-256, which is highly secure. The database is encrypted using ForestDB + libcrypto or [SQLCipher](https://www.zetetic.net/sqlcipher/), a fork of SQLite. Attachments are individually encrypted in the filesystem.

## Why to use encryption

Examples of cases when you might want to encrypt a Couchbase Lite database are:

- If your app needs to store private or confidential data
- If regulations such as HIPAA (Health Insurance Portability and Accountability Act) require you to use encryption

## Why to not use encryption

Examples of cases when you might not want to encrypt a Couchbase Lite database are:

- When data stored in the database is not private or confidential, so there is no need to store the data securely
- If you consider the native filesystem encryption on the mobile devices to be good enough for all use cases. Note that the native filesystem encryption might not be enabled by default, and that not all users will enable it. For example, on iOS, in order to enable encryption, a user must set up a device passcode. If s/he has done so, then all app files are encrypted with a key that is unavailable when the app is not running. On OS X, encryption is not enabled by default, though a user can opt into full-disk FileVault encryption.
- Key management can annoy the user. On the latest iOS devices, you can use Touch ID, but on earlier devices you must
prompt the user for a passcode when your app starts because, if you don't trust the built-in device security, that means that you don't trust the keychain to hold the key.
- There is a slight drop in performance. SQLCipher claims about 5-15% overhead in database I/O.
- Your app will be larger. You must embed a copy of SQLCipher in your application, instead of using the operating
system's built-in SQLite library.

## Enabling encryption

Refer to the [Database Guide](/documentation/mobile/current/guides/couchbase-lite/native-api/database/index.html#database-encryption) for instructions on how to enable encryption on each platform.

### Where to store the key

So where do you get this password or key from, that you register with the `Manager`? You have to store it someplace persistent so that it can be used on the next launch of the app to decrypt the database. You have two choices, pretty much:

- Store it in the user's brain (or on a sticky note or something). That is, force the user to make up a password and memorize it, and then to re-enter it on every launch of the app. If the user ever forgets the password, game over—the database is lost.
- Store it in a Touch ID-protected keychain item, on a modern iOS device with a Touch ID (fingerprint) sensor. This is much better because the user never has to remember anything or even see the key. Too bad not everyone has an iPhone 5s or later, though.

Following are some places that you `cannot` store the password:

- **Hard-coded into your app:** This is easy for an attacker to extract, and that breaks the security for every user of your app.
- **In a file:** The whole reason that you're using encryption is because you don't trust the security of the device's filesystem.
- **In an encrypted file:** This begs the question of where you store the encryption key for that file. See above.
- **In a regular keychain item:** This is slightly more secure than in a file, but in practice an attacker who can get through the filesystem encryption either has the device's passcode, or can make keychain calls pretending to be the app.

Why is a Touch ID-protected Keychain item safe when a regular Keychain item isn't? Because it has an additional layer of encryption provided by the secure enclave in the device's CPU, which will only decrypt the item when the user's fingerprint is present on the sensor. Hacking this requires either creating a detailed fake replica of the user's fingerprint, or some nano-scale manipulation of the running CPU chip.

### Generating good keys

Following is information about generating good keys:

- **If using a user-entered password:** The password needs to be hard to guess and hard to discover by brute-force methods. The principles are well known, starting with obvious quality rules such as a minimum character length, a broad character set (not just letters!), and so forth. Unfortunately, the stronger the password is, the less tolerable it is for the user to remember and to type it. Many apps give up entirely and just let the user set a short numeric code, which is completely insecure.
- **If generating a random binary key (for use with Touch ID, presumably):**
  - **Do** call `SecRandomCopyBytes` as your source of data.
  - **Don't** use a general-purpose random number generator, such as `random`, that is not random enough for cryptography.
  - **Don't** try to convert a password string into a key yourself unless you know a lot about cryptography, understand what `PBKDF2` is and how it works, and think you can do better.
