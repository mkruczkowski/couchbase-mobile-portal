var yaml = require('js-yaml')
  , fs = require('fs')
  , path = require('path')
  , mkdirp = require('mkdirp')
  , in_path = process.argv[2]
  , out_path = process.argv[3];


var output = [];
var date = new Date().valueOf();
findFiles('.', '.yaml', [])
  .forEach(function (file) {
    convertFile(file, 'tmp');
  });

function convertFile(sourceFile, destinationFolder) {
  var obj = yaml.load(fs.readFileSync(sourceFile, {encoding: 'utf-8'}));
  var outputDirectoryPath = path.join(destinationFolder, path.dirname(sourceFile), 'configs');
  var outputFilePath = path.join(outputDirectoryPath, path.basename(sourceFile).replace('.yaml', '.' + date + '.json'));
  mkdirp(outputDirectoryPath, function (err) {
    if (err) console.error(error);
    else fs.writeFileSync(outputFilePath, JSON.stringify(obj, null, 2));
  })
}

/**
 * Recursively looks up for all the files with a given extension in the specified directory.
 * @param startPath
 * @param extension
 */
function findFiles(startPath, extension, output) {
  var files = fs.readdirSync(startPath);
  files.forEach(function (file) {
    var filename = path.join(startPath, file);
    var stat = fs.lstatSync(filename);
    if (stat.isDirectory()) {
      findFiles(filename, extension, output);
    } else if (filename.indexOf(extension) >= 0) {
      output.push(filename);
    }
  });
  console.log(output)
  return output;
}