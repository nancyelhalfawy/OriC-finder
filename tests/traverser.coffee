

dna = "CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA"
# dna = "AGTCGATGCTTAGCCA"
# dna = "AAAAAGTCGATGCTTAGCCA"
# dna = "AGTGT"
# dna = "ATGATCATCTTC"
window.tree = {branches:{}}
window.k = 6

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


window.traverseCommander =

	funcs: []

	listen: (f, context = null) ->
		@funcs.push { func: f, context: context }
		return @funcs.length - 1

	dismiss: (i) ->
		@funcs[i] = false

	walk: (n = 1) ->
		for i in [0...n]
			@funcs.forEach (f) -> if f then f.func.call f.context



window.traverser_list_of_success = []

class Traverser

	paths: []

	constructor: (@start, @sequence) ->
		traverseCommander.listen @walk, @

		@paths.push
			distance_traveled: -1, # uninitialized
			stroll: []
			tollerance: 2,
			branches: tree.branches


	spawn: (parent_path) ->
		# @sequence[parent_path.distance_traveled]

		for key, val of parent_path.branches
			stroll = parent_path.stroll.concat key # add the current start of ghost-branch as the end of the lats stroll
			branches = val.branches
			@paths.push
				distance_traveled: parent_path.distance_traveled
				tollerance: parent_path.tollerance
				stroll: stroll
				branches: branches

	candidates: []

	end: (path) ->
		if not path.hasOwnProperty 'branches'
			@candidates.push path
		else
			for key, val of path
				@candidates.push val
	walk: ->

		addition = []
		deletion = []

		for path, index in @paths

			# distance needs to update
			# the stroll needs to update
			# the tollerance need to update if check fails
			# the branches need to update
			
			path.distance_traveled++

			current_bp = @sequence[path.distance_traveled]

			# ERROR SOME INDEXING ERROR
			if not current_bp
				console.count()
				continue



			if path.branches.hasOwnProperty current_bp
				# Well, the traverser is just fine right here


				path.stroll.push current_bp
				path.branches = path.branches[current_bp].branches

				if path.distance_traveled >= (k - 1) # ohh wow, we have hit the end and found a matching sequence in the tree
		 			if not path.branches[current_bp] then debugger
					@end path.branches[current_bp]
					deletion.push index


			else if path.tollerance > 0
				# At this point we are in the branch e.g. A-T-G-A at the last char, A
				# If the tollerance of the path is high enough, 
				# this path dies, but gives rise to (up to) 3 other paths (TCG) which
				# will inherit the properties of current path. As all of those new paths
				# have passed true on this current if-else statement.

				# There is an exception, if the distance_traveled has reached k, and tollerance => 0
				# then we have found a ending with Object.keys(path.branches).length potential endings


				# spawn takes care of updating the stroll and branches for the ghost-path
				path.tollerance--

				if Object.keys(path.branches).length > 1 # there are sibbling branches available
					if path.distance_traveled >= (k - 1) # set Object.keys(path.branches) as potential last bp in sequences
						@end path.branches
						deletion.push index
						console.count()
					else
						addition.push index # the @paths index from which new branches will spawn
				else # There are no sibblings available and distance_traveled has reached k
					# There are no other sub branches on which ghost-paths can spawn
					deletion.push index

			else
				deletion.push index



		for index in addition
			@spawn @paths[index]

			deletion.push index # this @paths index which didnt traverse to the end.

		for i in deletion

			@paths.splice i, 1

# bullshit code
max = 0
# bullshti code end

reverseComplement = (string) ->
	complements =
		"A": "T"
		"T": "A"
		"G": "C"
		"C": "G"

	ns = ""
	ns = complements[i] + ns for i in string
	ns



class ClumpTraverser
	constructor: (@sequence, @start_point, threshold = 1) ->

		@paths = []

		@distance_traveled = 0
		base_tollerance = threshold + 1

		for bp, val of tree.branches
			@spawn
				tollerance: if @sequence[@distance_traveled] is bp then base_tollerance else base_tollerance - 1
				subpath: val.branches
				bp: bp
				spts: val.spts
				stroll: [bp]

		# if @start_point is 2 then debugger
		@commander_id = traverseCommander.listen @walk, @

	spawn: (ob) ->
		@paths.push ob


	walk: ->

		@distance_traveled++

		deletion = []

		for path, index in @paths

			path.delete = true

			for bp, subpath of path.subpath #spawn the sub branches
				ts = 
					tollerance: if @sequence[@distance_traveled] is bp then path.tollerance else path.tollerance - 1
					subpath: subpath.branches
					bp: bp
					spts: subpath.spts
					stroll: path.stroll.concat(bp)
				# if @start_point is 1 then debugger
				@spawn ts


		@paths = _.reject @paths, (ob) -> !!ob.delete

		@validatePaths()

		if @distance_traveled >= k - 1
			@end()


	validatePaths: ->
		deletion = []
		for path, index in @paths when path.tollerance <= 0
			path.delete = true

		@paths = _.reject @paths, (ob) -> !!ob.delete



	end: ->
		# bullshti code start
		if @paths.length >= max

			strolls = _.pluck @paths, 'stroll'
			for i, index in strolls
				strolls[index] = i.join('')

			window.traverser_list_of_success.push {count: @paths.length, seq: @sequence, strolls: strolls, ob: @}

			if @paths.length > max
				max = @paths.length

		# bullshit code end

		traverseCommander.dismiss @commander_id


window.tlist = []
for i in [0..dna.length - k]

	seq = dna.substr i, k
	namespace i, seq

	traverseCommander.walk()

	tlist.push(new ClumpTraverser(seq, i, 2))
	tlist.push(new ClumpTraverser(reverseComplement(seq), i, 2))


traverseCommander.walk(k)

# Bullshit code start
window.traverser_list_of_success = _.reject window.traverser_list_of_success, (ob) ->
	ob.count < max - 1

window.max_s = []
window.traverser_list_of_success.forEach (ob) ->
	window.max_s = window.max_s.concat ob.strolls


window.max_s = _.uniq window.max_s
console.log max
console.log window.max_s


# bullshit code end


