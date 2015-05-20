
work = require('webworkify')

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


class Stage

	# old: 0
	# validate_freq: 1000
	# inner_stages: 2
	# max_value: settings.dna_length
	# value: 0

	# keepAlive: -> @value += 0.5
	# validate: ->
	# 	if @old is @value then return true
	# 	@old = @value
	# 	return false	

	constructor: (options) ->
		@current_stage = 0
		@max_stage = options.inner_stages - 1

		_.extend @, options

		@options = options

		@events = new EventListener()

	start: -> @interval_timer = window.setInterval(_.bind((() ->
		result = @options.validate.call @
		if result
			@events.trigger 'validate:true'
			@current_stage++
	), @), @options.validate_freq)

	getPercentage: ->
		@value / @max_value


	on: (what, cb) ->
		@events.on what, cb, @


class Progress

	constructor: ->
		@events = new EventListener()

	stages: []

	createStage: (options) ->
		stage = new Stage(options)
		@stages.push stage

		return stage

	start: ->
		@progress_timer = window.setInterval(_.bind((() ->

			@update()

		), @), 1000)

	stop: ->
		window.clearInterval @progress_timer
		for stage in @stages
			window.clearInterval stage.interval_timer
		@events.trigger 'stop'

	getPercentage: -> @percentage

	update: ->

		@percentage = 1
		for stage in @stages
			@percentage *= stage.getPercentage()

		@events.trigger 'update', @percentage

progress = new Progress()



class Workers

	end: (data) ->
		progress.stop()
		@class_events.trigger 'done', data

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
			@filterWorker.postMessage
				message: 'filter-push'
				data: data

		'filter-return filterWorker': (data) -> @end data
		# 'filtered-one filterWorker': (data) -> 


	constructor: (@settings = {}) ->

		# @orics = new Worker('/scripts/dnaa/dnaa-analyze.js')


		@class_events = {}
		_.extend @class_events, Backbone.Events

		@mainWorker = work(require('./workers/traverser.coffee'))
		@filterWorker = work(require('./workers/filter-worker.coffee'))
		@traverserWorker = work(require('./workers/traverser-worker.coffee'))

		@setUpEvents()

		stage = progress.createStage

			old: 0
			validate_freq: 1000
			inner_stages: 2
			max_value: @settings.dna_length
			value: 0

			keepAlive: ->
				@value++
			validate: ->
				if @old is @value then return true
				@old = @value
				return false



		@event_listeners.traverserWorker.on 'filter-push', (do (stage)-> -> stage.keepAlive()), @

		tht = @
		stage.on 'validate:true', do (tht) -> ->

			if @current_stage > 0 then return tht.filterWorker.postMessage message: 'filter-return'

			tht.traverserWorker.postMessage
				message: 'walk'
				data:
					times: tht.settings.k

		stage.start()


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


module.exports =
	Workers: Workers
	progress: progress
	EventListener: EventListener
	Stage: Stage
