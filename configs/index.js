var yaml = require('js-yaml')
  , fs = require('fs')
  , in_path = process.argv[2]
  , out_path = process.argv[3];

var obj = yaml.load(fs.readFileSync(in_path, {encoding: 'utf-8'}));
fs.writeFileSync(out_path, JSON.stringify(obj, null, 2));