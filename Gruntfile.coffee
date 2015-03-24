
# What i want my grunt file todo:
# 	

# require 'grunt'

_ = require 'underscore'

module.exports = (grunt) ->
	# browserify -c 'coffee -sc' main.coffee > bundle.js

	
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'


		browserify:
			dist:
				files:
					'public/build/bundle.js': ['public/scripts/app.coffee']
				options:

					browserifyOptions:
						debug: true
						extenstions: ['.coffee']

					transform: ['coffeeify']


		uglify:

			options:
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
			static_mappings:
				files: [{

					filter: 'isFile'
					src: 'public/build/app.js'
					dest: 'public/build/app.min.js'

				}]

		handlebars:

			compile: 

				options:
					# namespace: (filename) ->
					# 	names = filename.replace(/public\/scripts\/(.*)(\/\w+\.hbs)/, '$1')
					# 	names.split('/').join('.')
					# 	"app.#{names}.comething"

					processName: (filename) ->
						fna = filename.replace(/public\/scripts\/(.*)(\/(\w+)\.hbs)/, '$1.$3')

						# return 'wef.' + fna


					commonjs: true

				files:
					'public/build/templates.js': ['public/scripts/**/*.hbs']





	require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
	# grunt.loadNpmTasks 'grunt-contrib-uglify'

	grunt.registerTask 'build', ['handlebars', 'browserify']

	grunt.registerTask 'default', ['build']


