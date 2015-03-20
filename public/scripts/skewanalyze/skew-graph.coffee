
Backbone = require 'backbone'
require 'flot'



class SkewGraph extends Backbone.View

	render: () ->

		data = []
		totalPoints = 300

		getRandomData = () ->

			if data.length > 0
				data = data.slice(1);

			while data.length < totalPoints

				prev = if data.length > 0 then data[data.length - 1] else 50
				y = prev + Math.random() * 10 - 5

				if y < 0
					y = 0
				else if y > 100
					y = 100

				data.push(y)

			res = []
			for i in [0...data.length]
				res.push([i, data[i]])

			return res


		updateInterval = 30

		plot = $.plot(@$el, [ getRandomData() ], {
			series: {
				shadowSize: 0	
			},
			yaxis: {
				min: 0,
				max: 100
			},
			xaxis: {
				min: 0,
				max: 2000
			}
		})

		update = ->

			plot.setData([getRandomData()])

			plot.setupGrid()

			plot.draw()
			setTimeout(update, updateInterval)

		update()


module.exports = SkewGraph