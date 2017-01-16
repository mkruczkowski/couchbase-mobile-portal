var yaml = require('js-yaml')
  , outputfile = 'tmp/' + process.argv[2] + '.json'
  , fs = require('fs')
  , obj = yaml.load(fs.readFileSync(process.argv[2] + '.yaml', {encoding: 'utf-8'}));

fs.writeFileSync(outputfile, JSON.stringify(obj, null, 2));