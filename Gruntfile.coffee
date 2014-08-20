module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        watch:
            scripts:
                files: ['source/**/*.coffee']
                tasks: ['coffee']

        coffee:
            compile:
                expand: true
                flatten: true
                cwd: 'source'
                src: ['*.coffee']
                dest: 'app/scripts'
                ext: '.js'
                options:
                    sourceMap: true

    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    # Default task(s).
    grunt.registerTask 'default', ['coffee']
