g = require 'gulp'
electron = require('electron-connect').server.create()
packager = require('electron-packager')
$ = require('gulp-load-plugins')()
packageJson = require('./package.json')

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

g.task 'package', ['elm'], ->
  commonParam =
    dir: '.'
    out: 'release'
    name: packageJson.name
    arch: ['x64','ia32']
    version: '0.31.1'
    ignore: '(icons|release|node_modules|elm-stuff)'
    overwrite: true

  merge = (obj1,obj2) ->
    ret = {}
    ret[a] = obj1[a] for a of obj1
    ret[a] = obj2[a] for a of obj2
    ret

  darwinParam = merge commonParam, platform:'darwin', icon: './image/elmtrn.icns'
  linuxParam  = merge commonParam, platform:'linux',  icon: './image/elmtrn.png'
  win32Param  = merge commonParam, platform:'win32',  icon: './image/elmtrn.ico'
  packager darwinParam, (err, path) -> console.log err,path
  packager linuxParam , (err, path) -> console.log err,path
  packager win32Param , (err, path) -> console.log err,path

g.task 'default', ['elm-init','elm','watch',]
