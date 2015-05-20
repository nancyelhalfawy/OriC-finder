
util = require '../../server_/util.coffee'

logic = require './logic.coffee'

SynthesizedDNAGraph = require '../gc/synthesized-dna-graph.coffee'


Workers = logic.Workers
EventListener = logic.EventListener
Stage = logic.Stage

progress = logic.progress



class DnaAView extends Backbone.View

	rendered: false 

	setUp: (sandbox) ->

		@dna = util.storage.get('dna')
		@dna_meta = util.getSelectedDNAMeta()

		if not @rendered
			@templates = sandbox.templates
			@render()
			@rendered = true
		else
			@renderDNAGraph()


	calculate: (dna) ->

		data =
			dna_length: dna.length
			dna: dna
			start: 0
			end: dna.length

			# debugger

		workers = new Workers({
			k: 9
			dna_length: data.dna_length
		})

		workers.mainWorker.postMessage
			window_size: 500
			mutation_threshold: 1
			k: 9
			dna_length: data.dna_length
			DNA:
				dna: data.dna


		workers.class_events.on 'done', @done, @

		el_per = @$('.percentage')
		progress.events.on 'update', (percentage) ->
			el_per.html Math.round((percentage / 2) * 100).toString() + "%"
		progress.start()

		# worker.postMessage dna


	done: (data) ->
		@$('.output').html JSON.stringify(data)

	start: ->

		return

		if not dna or not dna.origins
			return alert('You need to select and preanalyze dna in GC skew')
		else
			@calculate dna.origins

	events: 
		'click #start-analyze': 'start'




	render: =>


		window.start = @calculate


		@$el.html @templates.content()


		if @dna_meta
			@$('#selected-dna').text @dna_meta.description

		@synthesizedDNAGraph = new SynthesizedDNAGraph()
		@synthesizedDNAGraph.setElement @$('#synthesized-dna-graph-buffer')
		@synthesizedDNAGraph.render()

		@renderDNAGraph()

		@synthesizedDNAGraph.on 'clicked', @selectOrigin, @

		@delegateEvents()


	getDNASubstring: (start, end) ->
		llen = @dna_meta.one_line_length

		first_line_sp = start % llen
		first_line = (start - first_line_sp) / llen
		first_bps = @dna.genome[first_line].slice(first_line_sp)

		last_line_ep = end % llen
		last_line = (end - last_line_ep) / llen
		last_bps = @dna.genome[last_line].slice(0, last_line_ep)

		middle_bps = @dna.genome.slice(first_line + 1, last_line - 1).join('')

		dna_ss = first_bps + middle_bps + last_bps

		return dna_ss

	selectOrigin: (id, attr) ->
		if not id.match(/^ori|^teri/) then return
		se = attr.match(/Start:\s(.*),\sEnd:\s(.*)$/).slice(1)
		start = se[0]
		end = se[1]

		@calculate @getDNASubstring(start, end)

	renderDNAGraph: ->

		if _.has(@dna, 'origins')
			@synthesizedDNAGraph.setOrigins @dna




class DnaA extends Backbone.Model

	id: 'dnaa'

	initialize: ->


		@view = new DnaAView()

		@on 'render', @render, @

	render: (sandbox) ->

		@view.setElement sandbox.element
		@view.setUp(sandbox)


module.exports = new DnaA()



