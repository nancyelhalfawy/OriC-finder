
Backbone = require 'backbone'
require 'flot'

_ = require 'underscore'



class SkewGraph extends Backbone.View

	initialize: -> @


	startAnalyze: (stuff) ->

		@worker = new Worker '/scripts/skewanalyze/skew-analyze.js'


		@collection.download window.localStorage.getItem('dna-id'), (result) =>

			@worker.postMessage _.extend result, stuff

		@worker.addEventListener 'message', (ev) =>

			done = false

			if ev.data.done
				@trigger 'done', ev.data
				done = true
			else
				@trigger 'loading', ev.data.progress

			@render ev.data, done, ev.data.origins




	terminateAnalyze: ->
		@worker.terminate()



	render: (data, done, origins) ->

		if not data
			data =
				data: []
				min:
					val: -1
				max:
					val: 1
				length: 1

		markings = []

		if done && origins
			for ori in origins
				markings.push {
					color: '#'+Math.floor(Math.random()*16777215).toString(16),
					lineWidth: 1,
					xaxis: {
						from: ori.bp_index
						to: ori.bp_index
					}
				}



		plot = $.plot(@$el, [ data.data ], {
			series: {
				shadowSize: 0	
			},
			yaxis: {
				min: data.min.val,
				max: data.max.val
			},
			xaxis: {
				min: 0,
				max: data.length
			},
			grid: {
				markings: markings
			}
		})


		plot.setData [data]

		plot.setupGrid()

		plot.draw()



module.exports = SkewGraph