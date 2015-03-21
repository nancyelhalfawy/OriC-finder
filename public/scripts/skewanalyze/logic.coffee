
Backbone = require 'backbone'
SkewGraph = require './skew-graph.coffee'
SynthesizedDNAGraph = require './synthesized-dna-graph.coffee'

util = require '../util.coffee'

GenBank = require '../GenBank.coffee'


class Skew extends Backbone.View


	setMetaStuff: ->
		stuff = 
			'#dna-name': 'name'
			'#selected-dna': 'description'

		dna_meta = util.getSelectedDNAMeta()

		for key, val of stuff
			@$(key).text if dna_meta then dna_meta[val] else '...'

		if dna_meta
			@$('#dna-length').text "~#{dna_meta['lines_length'] * 70}"
			@$('#dna-fna').text "#{dna_meta['remoteFNA'].slice(0, -4)}"


	setWindowSizeLabel: ->
		@$('#window-size-label').text $("#window-size").val()

	setSpeedCapLabel: ->
		val = $("#speed-cap").val() + 'hz'
		if val is '65hz' then val = 'uncapped'
		@$('#speed-cap-label').text val

	events:
		'change #window-size': 'setWindowSizeLabel'
		'change #speed-cap': 'setSpeedCapLabel'
		'click #start-analyze': 'start'
		'click #stop-analyze': 'stop'


	getSpeed: ->
		val = Number($("#speed-cap").val())
		if val > 60 then val = 'uncapped'
		return val

	start: (ev) ->

		$(ev.currentTarget).attr('disabled', 'disabled')
		$("#stop-analyze").attr('disabled', false)

		s = window.localStorage
		go = false
		try go = !!JSON.parse(s.getItem("DNA:#{s.getItem("dna-id")}:meta"))

		if go
			@skewView.startAnalyze @getSpeed()
		else
			alert 'Please select a dna!'

	toggleStop: ->
		$("#stop-analyze").attr('disabled', 'disabled')
		$("#start-analyze").attr('disabled', false)

	stop: (ev) ->
		@skewView.terminateAnalyze()
		@toggleStop()

	initialize: ->

		@on 'load', @render, @

	render: ->

		genBank = new GenBank()
		@skewView = new SkewGraph { collection: genBank }


		@skewView.on 'done', =>
			@$el.find('#skew-progress').text '100%'
			@toggleStop()


		@skewView.on 'loading', (progress) =>
			@$el.find('#skew-progress').text progress + '%'


		synthesizedDNAView = new SynthesizedDNAGraph()

		@$el.html @templates.layout()

		@skewView.setElement @$("#graph-placeholder")
		@skewView.render()

		synthesizedDNAView.setElement @$("#synthesized-dna-graph-buffer")
		synthesizedDNAView.render()

		@[i]() for i in [
			'delegateEvents',
			'setWindowSizeLabel',
			'setSpeedCapLabel',
			'setMetaStuff'
		]




module.exports = Skew