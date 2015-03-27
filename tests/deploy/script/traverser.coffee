

importScripts './traverser-algoritms.js' # requires global variables: tree, traverseCommander, filter, k, input

tree = {
	branches:{}
}
filter = new CandidateFilter()
traverseCommander = new EventListener()



initiate = (input) ->

	self.input = input
	k = self.k = input.k

	dna = input.DNA.lines.join('')

	for i in [0..dna.length - k]

		seq = dna.substr i, k
		namespace i, seq

		traverseCommander.walk()

		new Traverser seq, i, 2
		new Traverser reverseComplement(seq), i, 2, true


	traverseCommander.walk(k)

	filter.clean()

	self.postMessage filter



self.addEventListener (message) ->

	initiate(message.data)
