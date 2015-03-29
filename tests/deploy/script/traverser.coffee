



self.addEventListener 'message', (message) -> initiate(message.data)

initiate = (input) ->

	self.input = input
	k = self.k = input.k
	t = self.t = input.mutation_threshold

	dna = input.DNA.lines.join('')

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


	# once done do this

	# self.postMessage
	# 	message: 'walk'
	# 	data:
	# 		times: k
	
	# self.postMessage
	# 	message: 'request-filter-return'




