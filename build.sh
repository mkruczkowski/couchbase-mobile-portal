#!/usr/bin/env bash
TMP=tmp

rm -rf tmp
mkdir tmp

echo "Building..."
# Disable syntax highlighter when uploading to acct/prod server and use Redcarpet's Rouge syntax highlighter for local builds.
cd md-docs
if [[ ! -z ${2} ]]; then
		jekyll build --destination "../${TMP}" --config "_config.yml","_config.${1}.yml","_config.prod.yml"
	else
		jekyll build --destination "../${TMP}" --config "_config.yml","_config.${1}.yml"
fi
cd ..
java -jar site/gtor/saxon9.jar -xi -l:on -s:site/src/site-hippo.xml -xsl:site/gtor/hippo.xslt output-directory="${TMP}/"

if [[ ! -z ${2} ]]; then
	echo "Zipping..."	
	ditto -c -k --sequesterRsrc --keepParent "${TMP}" "tmp.zip"
	echo "Uploading..."
	echo "
	cd uploads/mobile
	put tmp.zip
	" > push.sh
	
	sftp -b push.sh -oIdentityFile=~/.ssh/couchbase_sftp.key couchbaseinc@static.hosting.onehippo.com
fi