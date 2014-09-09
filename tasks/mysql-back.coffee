_utils = require './utils'
module.exports = (grunt)->
  grunt.registerMultiTask 'backup4mysql', 'back up and import mysql', ()->
    done = this.async()
    defaultOptions =
      user: 'root'
      password: ''
      host: 'localhost'
      port: 3306
      database: false

    options = this.options defaultOptions

    return grunt.log.error "the database is undefined " if not options.database

    if @target.indexOf('recovery') is 0
      _utils.doRecovery options, @data, ()-> done()
    else
      _utils.doBackup options, @data, ()-> done()