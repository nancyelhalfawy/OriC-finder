
self.tree = {
	branches: {}
}

importScripts './traverser-algoritms.js'


Traverser = @Traverser
EventListener = @EventListener
namespace = @namespace
reverseComplement = @reverseComplement


@traverseCommander = new EventListener()



self.addEventListener 'message', (ev) ->

	message = ev.data.message
	data = ev.data.data

	switch message
		when 'traverse'

			seq = data.sequence
			index = data.index
			t = data.threshold

			namespace index, seq

			traverseCommander.walk()

			new Traverser seq, index, t, false
			new Traverser reverseComplement(seq), index, t, true

		when 'traverse-init'
			@input = data.input
			self.postMessage
				message: 'filter-init'
				data:
					input: @input

		when 'walk' then traverseCommander.walk data.times


