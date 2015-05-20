gamma = (r) -> Math.random()

module.exports = (self) ->
	self.addEventListener 'message', (ev) ->

		startNum = parseInt(ev.data)

		setInterval((->
			r = startNum / Math.random() - 1
			self.postMessage([ startNum, r, gamma(r) ])
		), 500);
