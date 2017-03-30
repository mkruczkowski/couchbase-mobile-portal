var gulp = require('gulp')
  , concat = require('gulp-concat')
  , runSequence = require('run-sequence')
  , swagger = require('gulp-swagger')
  , argv = require('yargs').argv
  , version = argv.version + '/';

var swaggerOptions = {
  parser: {
    $refs: {
      internal: false
    }
  }
};

/**
 * Concat the parameters into parameters/index.yaml
 */
gulp.task('params-cbl', function () {
  return gulp.src([version + 'parameters/common.yaml', version + 'parameters/cbl.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'parameters'));
});

gulp.task('params-sg', function () {
  return gulp.src([version + 'parameters/common.yaml', version + 'parameters/sg.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'parameters'));
});

/**
 * Concat the definitions into definitions/index.yaml
 */
gulp.task('definitions-cbl', function () {
  return gulp.src([version + 'definitions/common.yaml', version + 'definitions/cbl.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'definitions'));
});

gulp.task('definitions-sg', function () {
  return gulp.src([version + 'definitions/common.yaml', version + 'definitions/sg.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'definitions'));
});

/**
 * Concat the paths into paths/index.yaml
 */
gulp.task('paths-cbl', function () {
  return gulp.src([version + 'paths/common.yaml', version + 'paths/cbl.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'paths'));
});

gulp.task('paths-sg-public', function () {
  return gulp.src([version + 'paths/common.yaml', version + 'paths/sg/common.yaml', version + 'paths/sg/public.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'paths'));
});

gulp.task('paths-sg-admin', function () {
  return gulp.src([version + 'paths/common.yaml', version + 'paths/sg/common.yaml', version + 'paths/sg/admin.yaml'])
    .pipe(concat('index.yaml'))
    .pipe(gulp.dest(version + 'paths'));
});

/**
 * Build Swagger specs
 */

gulp.task('public', ['params-sg', 'definitions-sg', 'paths-sg-public'], function () {
  return gulp.src(version + 'public.yaml')
    .pipe(swagger('sync-gateway-public.json', swaggerOptions))
    .pipe(gulp.dest('tmp'))
});

gulp.task('admin', ['params-sg', 'definitions-sg', 'paths-sg-admin'], function () {
  return gulp.src(version + 'admin.yaml')
    .pipe(swagger('sync-gateway-admin.json', swaggerOptions))
    .pipe(gulp.dest('tmp'))
});

gulp.task('cbl', ['params-cbl', 'definitions-cbl', 'paths-cbl'], function () {
  return gulp.src(version + 'cbl.yaml')
    .pipe(swagger('couchbase-lite.json', swaggerOptions))
    // run the swagger js code
    .pipe(gulp.dest('tmp'))
});

gulp.task('build', function(done) {
  runSequence('public', 'admin', 'cbl', function() {
    console.log('Run something else');
    done();
  });
});

gulp.task('watch', ['build'], function () {
  gulp.watch('**/*.yaml', ['build']);
});