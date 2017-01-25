#!/usr/bin/env bash
TMP="${1}"

rm -rf tmp
mkdir tmp

echo "Building..."
jekyll build --source "md-docs/" --destination "${TMP}"
java -jar site/gtor/saxon9.jar -xi -l:on -s:site/src/site-hippo.xml -xsl:site/gtor/hippo.xslt output-directory="${TMP}/"

if [ -z {1} ]; then
	echo "Building release notes..."
	mono ~/Developer/GitHubReleaseNotes/src/App/bin/Debug/ReleaseNotesCompiler.CLI.exe create --owner couchbase --repository couchbase-lite-ios --targetcommitish master -u jamiltz -p Robobo12! -m 1.4.0 --exportmd
	mono ~/Developer/GitHubReleaseNotes/src/App/bin/Debug/ReleaseNotesCompiler.CLI.exe create --owner couchbase --repository couchbase-lite-java-core --targetcommitish master -u jamiltz -p Robobo12! -m 1.4.0 --exportmd
	mono ~/Developer/GitHubReleaseNotes/src/App/bin/Debug/ReleaseNotesCompiler.CLI.exe create --owner couchbase --repository couchbase-lite-net --targetcommitish master -u jamiltz -p Robobo12! -m 1.4.0 --exportmd
	mono ~/Developer/GitHubReleaseNotes/src/App/bin/Debug/ReleaseNotesCompiler.CLI.exe create --owner couchbase --repository sync_gateway --targetcommitish master -u jamiltz -p Robobo12! -m 1.4.0 --exportmd

	echo "Zipping..."	
	ditto -c -k --sequesterRsrc --keepParent "${1}" "tmp.zip"
	
	echo "Uploading..."
	echo "
	cd uploads/mobile
	put tmp.zip
	" > push.sh

	sftp -b push.sh -oIdentityFile=~/.ssh/cb_xfer_id_rsa cb_xfer@54.175.181.113
	
	curl -X POST "http://$JENKINS_USERNAME:$JENKINS_PASSWORD@build-ingestion.cbauthx.com/job/CouchbaseDocumentationJobs/job/Mobile/job/IngestStage/build\?delay\=0sec"
fi