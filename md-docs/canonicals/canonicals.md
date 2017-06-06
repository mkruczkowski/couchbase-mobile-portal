## Canonicals

> **Note:** this folder is for informational purposes only on the process used to deploy redirects. This folder should be removed once there is reasonable confidence that the 1.1.0 and 1.2 docs can be removed from the dev portal (i.e that redirects are implemented in the internals of the dev portal web server).

This document describes the steps to generate a documentation set for CBM 1.1.0 and 1.2 that includes an empty file with the relevant redirect to the latest (`/current`) documentation.

### Migrate the 1.1.0 and 1.2 site maps to the Jekyll build system.

**html-to-json.xsl** is an XSLT script that parses the site map in the root **index.html** file and outputs it as JSON. Example command:

```bash
saxon 110-index.html html-to-json.xsl --suppressXsltNamespaceCheck:on
```

The JSON structure must then be converted into YAML which is the data format used by Jekyll.

### Insert the redirects for each route

**11.yaml** and **12.yaml** now contain all of the sitemap. The redirect to the most relevant page must then be added manually. There were little changes between the 1.1.0 and 1.2 site maps. So most of the 1.2 redirects also apply to 1.1.0. To expedite the process, we used a diffing tool to copy over the redirects from 1.1.0 to 1.2.

### Generate doc set

**canonical-generator.js** is a script that reads the following properties from the site map (`_data/11.yaml` or `_data/12.yaml`):

- `path`: the path location to generate the file.
- `redirect_to`: the redirect URL to include as the canonical URL and in the `window.location.href` function.

Note: Generated files in `_11` and `_12` should not be checked in Git.

### Deploy

Once the files are generated, they can be outputted as html files with Jekyll for verification.

```bash
jekyll serve --port 4000 --config _config.yml,_config.11.yml --livereload --destination tmp
```

And then uploaded for ingestion.

```bash
bash build.sh 11 prod
# or
bash build.sh 12 prod
```