var browserify = require('browserify');
var buffer = require('vinyl-buffer');
var del = require('del');
var gulp = require('gulp');
var gulpUtil = require('gulp-util');
var minifyCss = require('gulp-minify-css');
var riotify = require('riotify');
var source = require('vinyl-source-stream');
var transform = require('vinyl-transform');
var uglify = require('gulp-uglify');
var watchify = require('watchify');

gulp.task('js', function() { bundle(false); });
gulp.task('watch', function() { bundle(true); });
gulp.task('css', function() {
  return gulp.src('gb-pcb-vis.css')
    .pipe(minifyCss())
    .pipe(gulp.dest('./dist/'))
});
gulp.task('clean', function(cb) {
  del(['dist/**'], cb);
});

function bundle(watch) {
  var bundler = (watch)
    ? watchify(browserify({
      cache: {},
      packageCache: {},
      standalone: 'gbPcbVis'
    }))
    : browserify({
      standalone: 'gbPcbVis'
    });

  bundler.add('./gb-pcb-vis.js');
  bundler.transform(riotify);

  bundler.on('update', bundle);
  bundler.on('log', gulpUtil.log);

  return bundler.bundle()
    .on('error', gulpUtil.log.bind(gulpUtil, 'Browserify Error'))
    .pipe(source('gb-pcb-vis.js'))
    .pipe(buffer())
    .pipe(uglify())
    .pipe(gulp.dest('./dist/'));
}

gulp.task('dist', ['js', 'css']);

gulp.task('default', ['watch']);
