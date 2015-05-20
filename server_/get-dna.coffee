# First look in localStorage
# Second look in /cache/id
# Third try /download/:id


# unless download is called, use the order First -> Second -> Third.

$ = require 'jquery'
_ = require 'underscore'




class AjaxTests

	constructor: (@url) ->
		run: @run
		validate: @validate

	run: (cbe, cbs) ->
		$.ajax
			url: @url
			success: cbs
			error: cbe

	validate: (callback) ->
		@run ((error) -> callback(false)), (data) ->
			@data = data
			callback.call @, true


class Tests

	constructor: (@id) ->
		@cache = new AjaxTests "/cache/#{@id}/dna.fna"
		@ftp = new AjaxTests "/download/#{@id}"


	localStorage:
		run: ->
			return window.localStorage.getItem "DNA:#{@id}"
		validate: (callback) ->
			@data = @run()
			callback.call @, if @data then true else false


	setOrder: (what) =>
		@tries = what

	run: (cb) =>

		debugger

		i = 0
		max_i = @tries.length

		attempt = _.bind (->
			ctx = @[@tries[i]]
			ctx.id = @id

			ctx.validate.call ctx, (result) ->

				if not result
					i++

					if i is max_i then return

					attempt()
				else
					cb @data
		), @


		attempt()





module.exports = do ->

	get: (id, callback) ->

		tests = new Tests(id)
		tests.setOrder ['localStorage', 'ftp']
		tests.run callback

	download: (id, callback) ->

		test = new AjaxTests '/download/' + id
		test.run ((error) -> callback(error)), (success) -> callback


