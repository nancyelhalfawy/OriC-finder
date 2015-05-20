




initiate = (input, self) ->

	k = input.k
	t = input.mutation_threshold

	dna = input.DNA.dna

	self.postMessage
		message: 'traverse-init'
		data:
			input: input

	
	for i in [0..dna.length - k]

		self.postMessage
			message: 'traverse'
			data:
				sequence: dna.substr i, k
				index: i
				threshold: t




module.exports = (self) ->
	self.addEventListener 'message', (message) -> initiate(message.data, self)


