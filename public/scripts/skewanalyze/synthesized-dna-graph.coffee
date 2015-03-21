
require 'raphael'
require 'morris.js'

Backbone = require 'backbone'

class SynthesizedDNAGraph extends Backbone.View

	render: ->

		ths = @

		@morris = Morris.Donut({
			element: @el,
			data: [
				{label: "Leading Strand", value: 1000},
				{label: "OriC", value: 100},
				{label: "Lagging Strand", value: 1000},
				{label: "TeriC", value: 100},
			],
			formatter: (y, data) ->
				pos = ths.morris_format[data.label]

				if not pos then return y

				"Start: #{pos.start}, End: #{pos.end}"

		})

	morris_format: {}

	setOrigins: (data) ->

		# @morris.setData
		# data.unshift
		# @morris.select index

		if not data.origins then return

		bp_length = data.length
		origins = data.origins
		window_size = data.window_size

		chromo = []

		for chro in origins
			type = if chro.type is 'minimum' then 'ori' else 'teri'
			chromo.push
				index: chro.bp_index - window_size / 2
				type: type
				value: window_size





		chromo.unshift
			type: if chromo[0].type is 'ori' then 'lagging' else 'leading'
			value: chromo[0].index
			index: 0

		i = 2
		while i < chromo.length

			last = chromo[i - 1]
			current = chromo[i]
			chromo.splice i, 0,
				type: if current.type is 'ori' then 'lagging' else 'leading'
				index: last.index + last.value
				value: current.index - last.index

			i+=2


		chromo.push do ->
			last = chromo[chromo.length - 1]
			index = chromo[chromo.length - 1].index + chromo[chromo.length - 1].value

			type: if last.type is 'ori' then 'leading' else 'lagging'
			value: bp_length - index
			index: index



		morris_data = []
		select_id = 0

		morris_colors = []

		for chro, index in chromo by -1

			id = "#{chro.type}:#{index}"

			@morris_format[id] =
				start: chro.index
				end: chro.index + chro.value

			if chro.type is 'ori' then select_id = index

			switch chro.type
				when 'ori' then morris_colors.push('#0B62A4')
				when 'teri' then morris_colors.push('#3980B5')
				when 'leading' then morris_colors.push('#95BBD7')
				when 'lagging' then morris_colors.push('#B0CCE1')

			morris_data.push
				label: id
				value: chro.value

		@morris.options.colors = morris_colors
		console.log @morris
		@morris.setData morris_data
		@morris.select select_id








module.exports = SynthesizedDNAGraph