## Config file specs

This directory contains the information for the config file documentation. It is maintain in YAML and then must be converted to JSON and uploaded to s3.

The SG and SGA config pages on the developer portal will then use those to populate the page.

### Uploading the specs to s3

In the current directory, run the following commands:

```bash
s3cmd --acl-public -r put tmp/ s3://couchbase-docs/mobile/1.3/configs/
```