var gulp = require('gulp'),
    watch = require('gulp-watch'),
    elm  = require('gulp-elm'),
    clean = require('gulp-clean'),
    browserSync = require('browser-sync').create();

gulp.task('watch', function() {

    browserSync.init({
        notify: false,
        server: {
            baseDir: "app"
        }
    });

    watch('./app/index.html', function() {
        browserSync.reload();
    });

    watch('./app/styles/**/*.css', function () {
        gulp.start('cssInject');
    });

    watch('./app/src/Elm.elm', function () {
        gulp.start('elmCompilation');
    });
});

gulp.task('cssInject', function() {
    return gulp.src('./app/styles/style.css')
        .pipe(browserSync.stream());
});

gulp.task('cleanup-elm', function() {
    return gulp.src('./app/scripts/Elm.js')
        .pipe(clean({force: true}))
});

gulp.task('elmCompilation', ['cleanup-elm'], function() {
    return gulp.src('./app/src/Elm.elm')
        .pipe(elm().on('error', console.log))
        .pipe(gulp.dest('./app/scripts/'))
        .pipe(browserSync.stream());
});