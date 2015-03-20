
Backbone = require 'backbone'
SkewGraph = require './skew-graph.coffee'
SynthesizedDNAGraph = require './synthesized-dna-graph.coffee'

skewView = new SkewGraph()
synthesizedDNAView = new SynthesizedDNAGraph()


class Skew extends Backbone.View

	initialize: ->

		@on 'load', =>


			@$el.html @templates.layout()


			skewView.setElement @$("#graph-placeholder")
			skewView.render()


			synthesizedDNAView.setElement @$("#synthesized-dna-graph-buffer")
			synthesizedDNAView.render()




module.exports = Skew