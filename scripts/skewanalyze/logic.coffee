
Backbone = require 'backbone'
SkewGraph = require './skew-graph.coffee'
SynthesizedDNAGraph = require './synthesized-dna-graph.coffee'

util = require '../util.coffee'

GenBank = require '../GenBank.coffee'


class Skew extends Backbone.View

	initialize: ->

		@on 'navigate', @pagesetup, @
		@on 'load', @render, @

	render: ->

		genBank = new GenBank()
		@skewView = new SkewGraph { collection: genBank }

		synthesizedDNAView = new SynthesizedDNAGraph()

		@skewView.on 'done', (data) =>
			@$el.find('#skew-progress').text '100%'
			@toggleStop()
			synthesizedDNAView.setOrigins data

			util.storage.set 'dna', data


		@skewView.on 'loading', (progress) =>
			@$el.find('#skew-progress').text progress + '%'



		@$el.html @templates.layout()

		@skewView.setElement @$("#graph-placeholder")
		@skewView.render()

		synthesizedDNAView.setElement @$("#synthesized-dna-graph-buffer")
		synthesizedDNAView.render()

		@[i]() for i in [
			'delegateEvents'
		]

		@pagesetup()

	pagesetup: ->
		@[i]() for i in [
			'setMetaStuff',
			'setInclanationFreqLabel',
			'setWindowSizeLabel',
			'setSpeedCapLabel',
			'setThresholdLabel'
		]



	setInclanationFreqLabel: ->
		val = @$('#inclanation-freq').val()

		@$('#inclanation-freq-label').text util.getOrdinal(val)

	setWindowSizeLabel: ->
		window_size = @getWindowSize()

		incfv = Math.floor window_size / 7

		@$('#window-size-label').text window_size

		inc = @$('#inclanation-freq')
		inc.attr 'max', incfv

		if inc.val() > incfv
			inc.val incfv
			@setInclanationFreqLabel()
		else
			inc.val Number(inc.val()) - 1
			inc.val Number(inc.val()) + 1

	setSpeedCapLabel: ->
		val = $("#speed-cap").val() + 'hz'
		if val is '65hz' then val = 'uncapped'
		@$('#speed-cap-label').text val

	setThresholdLabel: ->
		val = $("#threshold").val()
		@$('#threshold-label').text 100 - Math.round(val / 0.15 * 100)

	events:
		'change #inclanation-freq': 'setInclanationFreqLabel'
		'change #window-size': 'setWindowSizeLabel'
		'change #speed-cap': 'setSpeedCapLabel'
		'change #threshold': 'setThresholdLabel'
		'click #start-analyze': 'start'
		'click #stop-analyze': 'stop'


	getSpeed: ->
		val = Number($("#speed-cap").val())
		if val > 60 then val = 'uncapped'
		return val

	getWindowSize: ->
		Number @$('#window-size').val()

	getInclanationFreq: ->
		Number @$('#inclanation-freq').val()

	getThreshold: ->
		Number @$('#threshold').val()


	start: (ev) ->

		$(ev.currentTarget).attr('disabled', 'disabled')
		$("#stop-analyze").attr('disabled', false)

		s = window.localStorage
		go = false
		try go = !!JSON.parse(s.getItem("DNA:#{s.getItem("dna-id")}:meta"))

		if go
			@skewView.startAnalyze
				speed: @getSpeed()
				window_size: @getWindowSize()
				threshold: @getThreshold()
				inclanation_sample_frequency: @getInclanationFreq()
		else
			alert 'Please select a dna!'

	toggleStop: ->
		$("#stop-analyze").attr('disabled', 'disabled')
		$("#start-analyze").attr('disabled', false)

	stop: (ev) ->
		@skewView.terminateAnalyze()
		@toggleStop()





	setMetaStuff: ->
		stuff = 
			'#dna-name': 'name'
			'#selected-dna': 'description'
			'#dna-length': 'bp_length'

		dna_meta = util.getSelectedDNAMeta()

		for key, val of stuff
			@$(key).text if dna_meta then dna_meta[val] else '...'

		if dna_meta
			@$('#dna-fna').text "#{dna_meta['remoteFNA'].slice(0, -4)}"

			@$('#window-size').attr
				max: dna_meta.bp_length / 5
				value: dna_meta.bp_length / 10






module.exports = Skew