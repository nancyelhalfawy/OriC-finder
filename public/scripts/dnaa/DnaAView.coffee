
backbone = require 'backbone'

util = require '../util.coffee'

class DnaA extends Backbone.View

	initialize: ->

		@on 'load', @render

	start: ->

		dna = util.storage.get('dna')

		if not dna
			return alert('You need to select and preanalyze dna in GC skew')
		else
			console.log util.storage

	events: 
		'click #start-analyze': 'start'




	render: =>


		@$el.html @templates.content()

		dna_meta = util.getSelectedDNAMeta()

		if dna_meta
			@$('#selected-dna').text dna_meta.description

		@delegateEvents()




module.exports = DnaA
