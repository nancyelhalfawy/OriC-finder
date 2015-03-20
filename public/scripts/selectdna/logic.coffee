

Backbone = require 'backbone'
GenBank = require '../GenBank.coffee'
_ = require 'underscore'


class Router extends Backbone.Router

	initialize: ->

	routes:
		'selectdna/download/:id': 'download'
		'selectdna/select/:id': 'select'

	download: (what) ->
		# console.log "will download #{what}"
		# @genomes.download what, (result) ->
		# 	console.log result

	select: (what) ->

		# window.localStorage.setItem('dna-id', what)
		# console.log "will select #{what}"


class GenomeView extends Backbone.View

	retrieve: (cb) =>
		@collection.download @model.get('id'), _.bind( ((result) =>
			@model.set 'searched', true
			cb.call @, result
		), @)


	download: (ev) ->

		button = $(ev.currentTarget)

		@$('.loading').html @templates.downloading()

		button.attr 'disabled', 'disabled'

		@retrieve =>
			button.attr 'disabled', false
			@$('.download').html @templates.select()
			@$('.loading').html ''

	select: (ev) ->

		window.localStorage.setItem 'dna-id', @model.get('id')

		@retrieve =>
			console.log @collection.view
			@collection.view.setSelectedDNATitle()


	events:
		'click button.download-genome-link': 'download'
		'click button.select-genome-link': 'select'


	initialize: ->

		@genomes = new GenBank()

		@templates = @collection.templates




class Genome extends Backbone.Model

	initialize: ->

		@view = new GenomeView
			model: @
			collection: @collection


		@collection.on 'rendered', =>
			@view.setElement "#folder-#{@get('id')}.list-group-item"
			@view.delegateEvents()




class Genomes extends GenBank

	model: Genome

	generateAlphaTree: ->

		alphatree = []

		@comparator = (x, y) ->

			x = x.get('name')
			y = y.get('name')

			if x.toLowerCase() isnt y.toLowerCase()
				x = x.toLowerCase()
				y = y.toLowerCase()

			return x.localeCompare(y)


		@sort()

		if @filterSearched
			base = @where { searched: true }
		else
			base = @slice()

		base.forEach (model, index) =>
			fname = model.get('name')
			letter = fname[0].toLowerCase()
			id = model.get('id')

			last = alphatree[alphatree.length - 1]

			alphastructure =
				foldername: fname
				id: id
				downloaded: if not model.get('searched') then @templates.download({id: id}) else @templates.select({id: id})

			if alphatree.length > 0 and last.letter is letter
				last.folders.push alphastructure
			else
				alphatree.push({
					letter: letter,
					folders: [alphastructure]
				})

		return alphatree



	initialize: => @





class SelectDNA extends Backbone.View

	initialize: ->

		@on 'load', @download


	setSelectedDNATitle: ->

		id = window.localStorage.getItem 'dna-id'

		if id
			title = ""

			__dna = window.localStorage.getItem "DNA:#{id}:meta"
			if __dna
				dna = JSON.parse __dna
				title += "#{dna.description}"
			else
				title = '...'

			@$('#selected-dna').text title

	download: =>

		@collection = new Genomes
		@collection.templates = @templates
		@collection.view = @

		@collection.on 'ready', @render
		@fetchListing()


	fetchListing: () ->
		@collection.fetch

			reset: true

			success: (collection, response, options) ->

				if not options['ftp.listing'] then collection.filterSearched = true

				collection.trigger 'ready'

			error: (c, r, o) ->

				return console.error 'something went wrong when trying to fetch the data!', r, o


	render: =>

		@$el.html @templates.content({
			alphatree: @collection.generateAlphaTree()
		})

		@delegateEvents()

		router = new Router
		router.genBank = @collection

		@setSelectedDNATitle()


		@collection.trigger 'rendered'


	events: {
		'click .panel-heading': (ev) ->
			if $(ev.target).prop('tagName') isnt 'A' then $(ev.target).find('a').click()
	}




module.exports = SelectDNA

