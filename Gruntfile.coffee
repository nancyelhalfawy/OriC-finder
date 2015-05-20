module.exports = (grunt) ->
	# browserify -c 'coffee -sc' main.coffee > bundle.js

	
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		handlebars:

			compile: 

				options:
					# namespace: (filename) ->
					# 	names = filename.replace(/public\/scripts\/(.*)(\/\w+\.hbs)/, '$1')
					# 	names.split('/').join('.')
					# 	"app.#{names}.comething"

					processName: (filename) ->
						fna = filename.replace(/public\/pages_\/(.*)(\/(\w+)\.hbs)/, '$1.$3')

						# return 'wef.' + fna


					commonjs: true

				files:
					'public/build/templates.js': ['public/pages_/**/*.hbs']





	require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
	# grunt.loadNpmTasks 'grunt-contrib-uglify'

	grunt.registerTask 'build', ['handlebars']

	grunt.registerTask 'default', ['build']


