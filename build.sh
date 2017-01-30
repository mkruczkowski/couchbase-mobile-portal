#!/usr/bin/env bash
TMP="tmp"

rm -rf tmp
mkdir tmp

echo "Building..."
jekyll build --source "md-docs/" --destination "${TMP}" --config "md-docs/_config.yml","md-docs/_config.${1}.yml"
java -jar site/gtor/saxon9.jar -xi -l:on -s:site/src/site-hippo.xml -xsl:site/gtor/hippo.xslt output-directory="${TMP}/"

echo "Zipping..."	
ditto -c -k --sequesterRsrc --keepParent "${TMP}" "tmp.zip"

echo "Uploading..."
echo "
cd uploads/mobile
put tmp.zip
" > push.sh

sftp -b push.sh -oIdentityFile=~/.ssh/cb_xfer_id_rsa cb_xfer@54.175.181.113

curl -X POST "http://$JENKINS_USERNAME:$JENKINS_PASSWORD@build-ingestion.cbauthx.com/job/CouchbaseDocumentationJobs/job/Mobile/job/IngestStage/build\?delay\=0sec"