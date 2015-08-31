g = require 'gulp'
electron = require('electron-connect').server.create()
$ = require('gulp-load-plugins')()

g.task 'watch', ->
  g.watch ['app/src/**/*.elm'],['elm']
  electron.start()
  g.watch ['app/app.js', 'app/*.html'], ->
    electron.restart()
  g.watch [], ->
    electron.reload()

g.task 'elm-init', $.elm.init

g.task 'elm', ->
  g.src ['app/src/**/*.elm']
    .pipe $.logger()
    .pipe $.plumber()
    .pipe $.elm filetype:'html'
    .pipe g.dest "app"

g.task 'default', ['elm-init','elm','watch',]
