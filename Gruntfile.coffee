module.exports = (grunt)->
  grunt.initConfig(
    pkg: grunt.file.readJSON 'package.json'
    backup4mysql:
      options:
        user: 'root'
        password: ''
        host: 'localhost'
        port: 3306
        database: 'bhf'
      backup:{}
      recovery:{}
  )
  grunt.loadTasks 'tasks'