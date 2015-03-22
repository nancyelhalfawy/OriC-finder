
Backbone = require 'backbone'
_ = require 'underscore'

util = require './util.coffee'


class DataTest

	run: (buffer) ->

		b = false

		if not buffer then return b


		x = {}
		try
			x = JSON.parse buffer
		catch e
			return b

		
		if not _.isEmpty x then b = true

		@parse = x

		return b

	getResult: ->

		return @parse



class AjaxTests

	constructor: (@url) ->
		run: @run
		validate: @validate

	run: (cbe, cbs) ->

		$.ajax
			url: @url
			dataType: 'text'
			success: (data) ->

				test = new DataTest()
				result = test.run data
				if not result then return cbe()
				cbs test.getResult()

			error: cbe

	validate: (callback) ->
		@run ((error) -> callback(false)), (data) =>
			@data = data
			callback.call @, true

class LocalStorageTests

	constructor: (@what) ->
		run: @run
		validate: @validate

	run: -> return window.localStorage.getItem @what

	validate: (callback) ->

		buffer = @run()

		test = new DataTest()
		result = test.run buffer

		if result then @data = test.getResult()

		callback.call @, result

class Test
	

	constructor: (@id) ->

		tstL =
			'cache.listing': new AjaxTests "cache/gen-db/listing.json"
			'ftp.listing': new AjaxTests "download"
			'localStorage.listing': new LocalStorageTests "DNA"

		tstD =
			'cache.DNA': new AjaxTests "cache/gen-db/#{@id}/dna.json"
			'ftp.DNA': new AjaxTests "download/#{@id}"
			'localStorage.DNA': new LocalStorageTests "#{@id}:line:0"

		tst = if @id then tstD else tstL

		for key, val of tst
			util.createNamespace @, key, val


	setOrder: (what) =>
		@tries = what

	run: (cb) =>

		i = 0
		max_i = @tries.length

		got_result = false

		summary = {}

		attempt = _.bind (->

			ctx = util.getNamespace @, @tries[i]

			if @id then ctx.id = @id

			ctx.validate.call ctx, do (summary, tries = @tries) -> (result) ->

				if not result

					summary[tries[i]] = false

					i++

					if i is max_i then return

					attempt()
				else
					summary[tries[i]] = true
					cb { result: true, data: @data, summary: summary }
					got_result = true
		), @

		attempt()

		if i is max_i and not got_result then cb { result: false, summary: summary }



class GenBank extends Backbone.Collection

	# url: '/download'

	fetch: (options) =>

		test = new Test()
		test.setOrder ['ftp.listing', 'cache.listing', 'localStorage.listing']
		test.run (response) =>

			if not response.result then return options.error(@, '404', response.summary)

			if options.reset then @reset response.data else @set data

			if not response.summary['localStorage.listing']
				window.localStorage.setItem 'DNA', JSON.stringify(response.data)

			options.success(@, response.data, response.summary)

	download: (id, callback) ->

		test = new Test(id)
		test.setOrder ['localStorage.DNA', 'cache.DNA', 'ftp.DNA']
		test.run (response) =>

			if not response.result then return callback('404', response.summary)

			if not response.summary['localStorage.DNA']
				util.localStorage.saveDNA response.data


			callback response.data, response.summary








module.exports = GenBank

