module.exports = do -> class Router extends Backbone.Router

	rootURL: ""

	routes: {}

	setRootURL: (url) ->
		@rootURL = url

	getRootURL: -> @rootURL

	start: (routes) ->

		_.extend @routes, routes

		for key, val of @routes
			# @route key, 
			r = /\'(.*)\'|(\"(.*)\")/mgi
			match = r.exec val.toString()

			if match and match.length > 1
				name = match[1].replace(/\"|\'/, '')
				@route key, name, val
			else
				@route key, val


		Backbone.history.start
			pushState: true
			root: @rootURL


