
Backbone = require 'backbone'
require 'flot'



class SkewGraph extends Backbone.View

	initialize: -> @

	startAnalyze: (speed) ->

		@worker = new Worker '/scripts/skewanalyze/skew-analyze.js'


		@collection.download window.localStorage.getItem('dna-id'), (result) =>
			result.speed = speed
			@worker.postMessage result

		@worker.addEventListener 'message', (ev) =>

			if ev.data.done
				@trigger 'done'
			else
				@trigger 'loading', ev.data.progress


			@render ev.data


	terminateAnalyze: ->
		@worker.terminate()



	render: (data) ->

		if not data
			data =
				data: []
				min:
					val: -1
				max:
					val: 1
				length: 1



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
			}
		})


		plot.setData [data]

		plot.setupGrid()

		plot.draw()



module.exports = SkewGraph