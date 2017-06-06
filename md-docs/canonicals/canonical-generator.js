var argv = require('yargs').argv,
  version = argv.version,
  inputfile = version + '.yaml',
  yaml = require('js-yaml'),
  fs = require('fs'),
  sitemap = yaml.load(fs.readFileSync(inputfile, {encoding: 'utf-8'}));

function mapPathToFile(routes) {
  routes.forEach(function(route) {
    mapRouteToFile(route);
    if (route.items) {
      mapPathToFile(route.items);
    }
  });
};
var mkdirp = require('mkdirp');
var getDirName = require('path').dirname;
function mapRouteToFile(route) {
  var text = '---\n' +
    'permalink: ' + route.path + '\n' +
    'redirect_to: ' + route.redirect_to + '\n' +
    '---';

  mkdirp(getDirName('../_' + version + '/' + route.path), function (err) {
    if (err) return cb(err);

    fs.writeFile('../_' + version + '/' + route.path.replace('.html', '.md'), text, function (err) {
      if (err) return console.log(err);
    });
  });
};

mapPathToFile(sitemap);
