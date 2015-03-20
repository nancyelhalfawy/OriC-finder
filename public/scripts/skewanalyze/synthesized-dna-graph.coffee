
require 'raphael'
require 'morris.js'

Backbone = require 'backbone'

class SynthesizedDNAGraph extends Backbone.View

	render: ->

		Morris.Donut({
			element: @el,
			data: [
				{label: "Leading Strand", value: 1000},
				{label: "OriC", value: 100},
				{label: "Lagging Strand", value: 1000},
				{label: "TeriC Strand", value: 100},
			],
			formatter: (y, data) ->
				return data.label
		})




module.exports = SynthesizedDNAGraph