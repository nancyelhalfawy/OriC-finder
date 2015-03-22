
backbone = require 'backbone'

util = require '../util.coffee'

class DnaA extends Backbone.View

	initialize: ->

		@on 'load', @render

	calculate: (dna) ->
		worker = new Worker('/scripts/dnaa/dnaa-analyze.js')
		worker.postMessage dna

	start: ->

		dna = util.storage.get('dna')

		if not dna
			return alert('You need to select and preanalyze dna in GC skew')
		else
			@calculate dna

	events: 
		'click #start-analyze': 'start'




	render: =>


		@$el.html @templates.content()

		dna_meta = util.getSelectedDNAMeta()

		if dna_meta
			@$('#selected-dna').text dna_meta.description

		@delegateEvents()




module.exports = DnaA
