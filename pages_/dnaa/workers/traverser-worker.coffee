
global = {}

global.tree = {
	branches: {}
}


dataReceived = (ev, algorithms) ->
	message = ev.data.message
	data = ev.data.data

	switch message
		when 'traverse'

			seq = data.sequence
			index = data.index
			t = data.threshold

			algorithms.namespace index, seq

			global.traverseCommander.walk()

			new algorithms.Traverser seq, index, t, false
			new algorithms.Traverser algorithms.reverseComplement(seq), index, t, true

		when 'traverse-init'
			global.input = data.input
			self.postMessage
				message: 'filter-init'
				data:
					input: global.input

		when 'walk' then global.traverseCommander.walk data.times


module.exports = (self) ->

	Algoritms = require './traverser-algoritms.coffee'

	algorithms = new Algoritms(global, self)
	global.traverseCommander = new algorithms.EventListener()

	self.addEventListener 'message', (ev) -> dataReceived(ev, algorithms)

