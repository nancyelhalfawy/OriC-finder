

dna = "CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA"
dna = "ATGATCTG"
tree = {branches:{}}
k = 5

namespace = (start_point, string) ->
	ns = string.split('')
	b = tree
	
	for p, index in ns
		if b.branches.hasOwnProperty p
			b = b.branches[p]
		else
			b.branches[p] = 
				spts: []
				branches: {}
				value: p
			b = b.branches[p]
		
		b.sps.push i + start_point
	
	return tree[ns[0]]


traverseCommander =
	on: ->

class Traverser
	constructor: (@start_point, @distance, @sequence) -> @
	wildcards: 2
	traveled: 0
	traverse_paths: []

	traverse: ->
		deletion = []
		addition = []

		for path, index in @traverse_paths when not path.branches.hasOwnProperty @sequence[@traveled]

			if path.tolerance <= 1
				deletion.push index
			else
				addition.push index


		for i in deletion
			@traverse_paths.splice i, 1
		for i in addition
			@traverse_paths.push { branches: val.branches, type: "ghost-clone", tolerance: tolerance }

		@traveled++



	cloneInto: (branch, tolerance = @wildcards) ->
		for leaf, val of branch
			@traverse_paths.push { branches: val.branches, type: "ghost-clone", tolerance: tolerance }
	init: ->
		if not tree.branches.hasOwnProperty @sequence[0]
			@wildcards--
			@cloneInto tree.branches
		else
			@traverse_paths.push { branches: tree.branches[@sequence[0]].branches, type: "main" }

		@traveled++

		traverseCommander.onwalk @traverse

for i in [0...dna.length]
	seq = dna.substr i, k
	namespace i, seq
	#traverser = new Traverser(i, k, seq)
	#traverser.init()

console.log tree