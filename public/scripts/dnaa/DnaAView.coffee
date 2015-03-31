
backbone = require 'backbone'
_ = require 'underscore'

util = require '../util.coffee'

class EventListener

	constructor: -> @

	evs: {}

	on: (what, cb, context = null) ->

		if not @evs.hasOwnProperty(what) then @evs[what] = { cbs: [] }

		cbs = @evs[what].cbs

		id = if cbs.length is 0 then 0 else cbs[cbs.length - 1].id + 1

		cbs.push { cb: cb, id: id, context: context }

		return id


	off: (what, id) ->

		cbs = @evs[what].cbs

		cbs_object = _.findWhere cbs, { id: id }

		if not cbs_object then return 

		index = cbs.indexOf cbs_object

		if index < 0 then return debugger

		cbs.splice index, 1

	trigger: (what, args...) ->

		if not @evs.hasOwnProperty what then return

		for cbs_object in @evs[what].cbs

			cbs_object.cb.apply cbs_object.context, args



class Workers

	end: (data) ->
		console.log data

	events:

		'traverse-init mainWorker': (data) ->
			@traverserWorker.postMessage
				message: 'traverse-init'
				data: data

		'traverse mainWorker': (data) ->
			@traverserWorker.postMessage
				message: 'traverse'
				data: data 

		'filter-init traverserWorker': (data) ->
			@filterWorker.postMessage
				message: 'filter-init'
				data: data

		'filter-push traverserWorker': (data) ->
			@is_ended++
			# bullshit
			@percent += 0.5
			# end of bullshti
			@filterWorker.postMessage
				message: 'filter-push'
				data: data


		'filter-return filterWorker': (data) -> @end data
		'filtered-one filterWorker': (data) -> @is_ended--


	constructor: (@settings = {}) ->

		# @orics = new Worker('/scripts/dnaa/dnaa-analyze.js')
		@mainWorker = new Worker('/scripts/dnaa/build/traverser.js')
		@filterWorker = new Worker('/scripts/dnaa/build/filter-worker.js')
		@traverserWorker = new Worker('/scripts/dnaa/build/traverser-worker.js')

		@setProgress()

		@setUpEvents()


	setProgress: ->

		@is_ended = 0

		done_count = 0
		last_kmers = 0

		tht = @

		interval_check = setInterval (->
			if tht.is_ended is 0 then done_count++ else done_count = 0
			if done_count > 20

				console.log 'almost done'

				last_kmers++
				if last_kmers is 1
					tht.is_ended = 0
					done_count = 0
					tht.traverserWorker.postMessage
						message: 'walk'
						data:
							times: tht.settings.k
							# Get this k value form settings
				else if last_kmers is 2
					console.log 'absolutly done'
					window.clearInterval interval_check
					tht.filterWorker.postMessage message: 'filter-return'

		), 100

		@percent = 0
		perinterval = setInterval (->
			val = Math.round((tht.percent / tht.settings.dna_length) * 100)
			console.log val, "%"

			if val is 100 then window.clearInterval perinterval

		), 1000

	setUpEvents: ->

		@event_listeners = {}

		for key, cb of @events
			pts = key.split ' '

			listen_on = pts[1]
			listen_for = pts[0]

			if not @event_listeners[listen_on]

				@event_listeners[listen_on] = new EventListener

				@[listen_on].addEventListener 'message', @getWorkerListener(listen_on)


			@event_listeners[listen_on].on listen_for, cb, @

	getWorkerListener: (listen_on) ->

		listener = @event_listeners[listen_on]

		do (listener) -> (ev) ->
			message = ev.data.message
			data = ev.data.data

			listener.trigger message, data



class DnaA extends Backbone.View

	initialize: ->

		@on 'load', @render

	calculate: (dna) ->

		worker = new Worker('/scripts/dnaa/dnaa-analyze.js')
		worker.addEventListener 'message', (ev) ->

			data = ev.data.data

			# debugger

			workers = new Workers({
				k: 9
				dna_length: data.dna_length
			})

			workers.mainWorker.postMessage
				window_size: 500
				mutation_threshold: 2
				k: 9
				dna_length: data.dna_length
				DNA:
					dna: data.dna

		worker.postMessage dna



	start: ->

		dna = util.storage.get('dna')

		if not dna
			return alert('You need to select and preanalyze dna in GC skew')
		else
			@calculate dna

	events: 
		'click #start-analyze': 'start'




	render: =>


		@$el.html @templates.content()

		dna_meta = util.getSelectedDNAMeta()

		if dna_meta
			@$('#selected-dna').text dna_meta.description

		@delegateEvents()




module.exports = DnaA
