

# dna = "CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA"
# dna = "ATGATCTG"
dna = "AAAAAGTCGATGCTTAGCCA"
tree = {branches:{}}
k = 4

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
		

		b.spts.push index + start_point
	
	return tree[ns[0]]


traverseCommander =

	funcs: []

	listen: (f, context = null) ->
		@funcs.push { func: f, context: context }
		return @funcs.length

	dismiss: (i) ->
		@funcs.splice i, 1

	walk: (n = 1) ->
		for i in [0...n]
			@funcs.forEach (f) -> f.func.call f.context


traverser_list_of_success = []

class Traverser

	constructor: (@start_point, @distance, @sequence) -> @
	wildcards: 2
	traveled: 0
	traverse_paths: []
	kmers: 0

	traverse: ->
		deletion = []
		addition = []

		for path, index in @traverse_paths when not path.branches.hasOwnProperty @sequence[@traveled]

			if path.tolerance <= 1
				deletion.push index
			else
				addition.push index


		for i in addition

			@cloneInto @traverse_paths[i].branches, tolerance = @traverse_paths[i].tolerance - 1
			deletion.push(i)

		for i in deletion
			@traverse_paths.splice i, 1

		if @traveled >= @distance
			@kmers++

		if @traverse_paths.length > 0
			@traveled++


	createPath: (branches, type, tolerance = @wildcards) ->
		return { branches: branches, type: type, tolerance: tolerance }

	cloneInto: (branch, tolerance = @wildcards) ->
		for leaf, val of branch
			@traverse_paths.push @createPath val.branches, "ghost-clone", tolerance
	init: ->
		if not tree.branches.hasOwnProperty @sequence[0]
			@wildcards--
			@cloneInto tree.branches
		else
			@traverse_paths.push @createPath tree.branches[@sequence[0]].branches, "main"

		@traveled++

		traverseCommander.listen @traverse, @

# build initial structure
for i in [0...k]
	seq = dna.substr i, k - i
	namespace i, seq

# To initial traverse to catch up with the building of the structure
seq = dna.substr 0, k
traverser = new Traverser(0, k, seq)
traverser.init()
traverseCommander.walk(k)

console.log traverser

for i in [1...dna.length - k] when i < 4

	seq = dna.substr i, k
	namespace i, seq

	traverseCommander.walk()

	traverser = new Traverser(i, k, seq)
	traverser.init()

	console.log traverser
