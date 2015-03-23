

dna = "CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA"
# dna = "ATGATCTG"
# dna = "AAAAAGTCGATGCTTAGCCA"
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

	constructor: (@start_point, @distance, @sequence) ->
		@kmers = 0
		@traverse_paths = []
		@

	wildcards: 2
	traveled: 0

	traverse: ->

		deletion = []
		addition = []

		for path, index in @traverse_paths

			path.distance_traveled++

			if path.distance_traveled > k
				traverser_list_of_success.push
					branches: path.branches
					sequence: @sequence
				deletion.push index

			if not path.branches.hasOwnProperty @sequence[@traveled]

				path.tolerance--

				if path.tolerance <= 1
					deletion.push index
				else
					addition.push index




		# if e.g. ATGAGAT gets match, on ATGAG$ but $ isnt A, then addition -> spawn clones
		# Otherwise, what should happend when path.distance_traveled is k?

		for i in addition
			atp = @traverse_paths[i]
			@cloneInto atp.branches, 'ghost-clone', atp.tolerance, atp.distance_traveled

			deletion.push(i)

		for i in deletion
			@traverse_paths.splice i, 1

		if @traverse_paths.length < 1 then return @end()



	end: ->
		traverseCommander.dismiss @commander_index

	createPath: (branches, type, tolerance = @wildcards, distance_traveled = 0) ->
		branches: branches
		type: type
		tolerance: tolerance
		distance_traveled: distance_traveled

	cloneInto: (branch, tolerance = @wildcards, distance_traveled = 0) ->
		for leaf, val of branch
			@traverse_paths.push @createPath val.branches, "ghost-clone", tolerance, distance_traveled
	init: ->
		if not tree.branches.hasOwnProperty @sequence[0]
			@wildcards--
			@cloneInto tree.branches
		else
			@traverse_paths.push @createPath tree.branches[@sequence[0]].branches, "main"

		@traveled++

		@commander_index = traverseCommander.listen @traverse, @

# build initial structure
# for i in [0...k]
# 	seq = dna.substr i, k - i
# 	namespace i, seq

# # To initial traverse to catch up with the building of the structure
# seq = dna.substr 0, k
# traverser = new Traverser(0, k, seq)
# traverser.init()
# traverseCommander.walk(k)

# console.log traverser.sequence, traverser.kmers, JSON.stringify traverser.traverse_paths

for i in [0...dna.length - k] when i < 14

	seq = dna.substr i, k
	namespace i, seq

	traverseCommander.walk()

	traverser = new Traverser(i, k, seq)
	traverser.init()

console.log traverser_list_of_success

# console.log tree