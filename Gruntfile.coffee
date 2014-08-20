module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        watch:
            scripts:
                files: ['source/**/*.coffee']
                tasks: ['clean', 'coffee']

        coffee:
            compile:
                expand: true
                flatten: true
                cwd: 'source'
                src: ['*.coffee']
                dest: 'app/scripts'
                ext: '.js'

        copy:
            main:
                expand: true
                src: ["source/**/*.coffee"]
                dest: "app/scripts/source/"
                filter: 'isFile'
                flatten: true

        clean:
            main: ["app/scripts"]

    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    # Default task(s).
    grunt.registerTask 'default', ['coffee']
