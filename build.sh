#!/usr/bin/env bash
TMP=tmp

rm -rf tmp
mkdir tmp

echo "Building..."
jekyll build --source "md-docs/" --destination "${TMP}" --config "md-docs/_config.yml","md-docs/_config.${1}.yml"
java -jar site/gtor/saxon9.jar -xi -l:on -s:site/src/site-hippo.xml -xsl:site/gtor/hippo.xslt output-directory="${TMP}/"

if [[ ${2} = "upload" ]]; then
	echo "Zipping..."	
	ditto -c -k --sequesterRsrc --keepParent "${TMP}" "tmp.zip"
	echo "Uploading..."
	echo "
	cd uploads/mobile
	put tmp.zip
	" > push.sh
	
	sftp -b push.sh -oIdentityFile=~/.ssh/couchbase_sftp.key couchbaseinc@static.hosting.onehippo.com
	
	curl -X POST "http://$JENKINS_USERNAME:$JENKINS_PASSWORD@52.200.81.196:8080/job/Ingestion%20Mobile%20-%20PROD%20ENV/build\?delay\=0sec"
fi